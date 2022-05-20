# frozen_string_literal: true

class StripeController < ApplicationController
  before_action :authenticate_user!, except: %i[webhooks]
  skip_before_action :verify_authenticity_token, only: %i[webhooks]
  before_action :verify_webhook, only: %i[webhooks]

  def checkout_session
    session = Stripe::Checkout::Session.create(checkout_session_args)
    redirect_to session.url, allow_other_host: true
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = error_message
    redirect_to users_settings_url
  end

  def success_callback
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    customer = Stripe::Customer.retrieve(session.customer)
    current_user.update(status: "active", stripe_customer_id: customer.id)

    FuguService.track("New Subscription")

    flash[:notice] = success_message
    redirect_to users_settings_url
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = error_message
    redirect_to users_settings_url
  end

  def customer_portal
    customer_portal_session = Stripe::BillingPortal::Session.create(
      {
        customer: current_user.stripe_customer_id,
        return_url: users_settings_url
      }
    )
    redirect_to customer_portal_session.url, allow_other_host: true
  rescue StandardError
    flash[:alert] = error_message
    redirect_to users_settings_url
  end

  def webhooks
    # cases:
    # - customer cancels subscription for the end of the billing cycle
    #   (customer.subscription.updated)
    # - subscription is canceled at the end of billing cycle (customer.subscription.deleted)
    # - customer re-activates canceled account before end of billing cycle
    #   (customer.subscription.updated)

    case params[:type]
    when "customer.subscription.updated"
      handle_subscription_updated
    when "customer.subscription.deleted"
      handle_subscription_deleted
    else
      head :ok
    end
  end

  def verify_webhook
    Stripe::Webhook.construct_event(
      request.raw_post,
      request.env["HTTP_STRIPE_SIGNATURE"],
      ENV.fetch("STRIPE_ENDPOINT_SECRET", nil)
    )
  rescue StandardError => e
    Sentry.capture_exception(e)
    head :not_found
  end

  private

  def success_message
    "Subscription successful. Enjoy Fugu 🎉🐡"
  end

  def error_message
    "Something went wrong. Please try again or contact me at canolcer@hey.com"
  end

  def sub_cancel_at_period_end
    params[:data][:object][:cancel_at_period_end]
  end

  def sub_customer_id
    params[:data][:object][:customer]
  end

  def handle_subscription_updated
    user = User.find_by(stripe_customer_id: sub_customer_id)
    if sub_cancel_at_period_end && !user.canceled?
      user.update!(status: "canceled")
    elsif !sub_cancel_at_period_end
      user.update!(status: "active")
    end

    head :ok
  rescue StandardError => e
    Sentry.capture_exception(e)
    head :internal_server_error
  end

  def handle_subscription_deleted
    User.find_by(stripe_customer_id: sub_customer_id).update!(status: "inactive")
    head :ok
  rescue StandardError => e
    Sentry.capture_exception(e)
    head :internal_server_error
  end

  def checkout_session_args
    {
      payment_method_types: ["card"],
      customer_email: current_user.stripe_customer_id ? nil : current_user.email,
      customer: current_user.stripe_customer_id,
      line_items: [{
        price: ENV.fetch("STRIPE_STANDARD_PRICE_ID", nil),
        quantity: 1
      }],
      mode: "subscription",
      success_url: "#{stripe_success_callback_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: users_settings_url
    }
  end
end
