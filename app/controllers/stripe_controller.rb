# frozen_string_literal: true

class StripeController < ApplicationController
  #skip_before_action :verify_authenticity_token, only: %i[webhooks]
  #before_action :verify_webhook, only: %i[webhooks]

  def checkout_session
    session = Stripe::Checkout::Session.create(checkout_session_args)
    redirect_to session.url
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = "Something went wrong. Please try again or contact me at canolcer@hey.com"
    redirect_to users_settings_url
  end

  def success_callback
    session = Stripe::Checkout::Session.retrieve(params[:session_id])
    customer = Stripe::Customer.retrieve(session.customer)
    current_user.update(status: "active", stripe_customer_id: customer.id)

    flash[:notice] = "Subscription successful. Enjoy Fugu 🎉🐡"
    redirect_to users_settings_url
  rescue StandardError => e
    Sentry.capture_exception(e)
    flash[:alert] = "Something went wrong. Please try again or contact me at canolcer@hey.com"
    redirect_to users_settings_url
  end

  # def customer_portal
  #   customer_portal_session = Stripe::BillingPortal::Session.create(
  #     {
  #       customer: current_user.account.stripe_customer_id,
  #       return_url: dashboard_account_settings_url
  #     }
  #   )
  #   redirect_to customer_portal_session.url
  # rescue StandardError
  #   flash[:alert] = 'Something went wrong. Please try again or contact us at bonjour@mapzy.io'
  #   redirect_to dashboard_account_settings_url
  # end

  private

  def checkout_session_args
    {
      payment_method_types: ["card"],
      customer_email: current_user.stripe_customer_id ? nil : current_user.email,
      customer: current_user.stripe_customer_id,
      line_items: [{
        price: ENV["STRIPE_STANDARD_PRICE_ID"],
        quantity: 1
      }],
      mode: "subscription",
      success_url: "#{stripe_success_callback_url}?session_id={CHECKOUT_SESSION_ID}",
      cancel_url: users_settings_url
    }
  end
end
