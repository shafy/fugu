# frozen_string_literal: true

module StripeTestHelper
  def stripe_event_signature(event_json)
    secret = ENV.fetch("STRIPE_ENDPOINT_SECRET", nil)
    timestamp = Time.zone.now
    signature = Stripe::Webhook::Signature.send(:compute_signature, timestamp, event_json, secret)
    scheme = Stripe::Webhook::Signature::EXPECTED_SCHEME
    "t=#{timestamp.to_i},#{scheme}=#{signature}"
  end

  def customer_subscription_updated(cancel_at_period_end, customer)
    {
      type: "customer.subscription.updated",
      data: {
        object: {
          cancel_at_period_end: cancel_at_period_end,
          customer: customer
        }
      }
    }
  end

  def customer_subscription_deleted(customer)
    {
      type: "customer.subscription.deleted",
      data: {
        object: {
          customer: customer
        }
      }
    }
  end

  def stripe_headers(event)
    {
      "Stripe-Signature" => stripe_event_signature(event.to_json)
    }
  end

  def checkout_session_args(price, customer)
    {
      payment_method_types: ["card"],
      customer: customer,
      line_items: [{
        price: price,
        quantity: 1
      }],
      mode: "subscription",
      success_url: "/",
      cancel_url: "/"
    }
  end

  def create_stripe_customer
    Stripe::Customer.create(source: StripeMock.generate_card_token(last4: "9191", exp_year: 2030))
  end

  def create_stripe_product
    Stripe::Product.create({ name: "Fugu" })
  end

  def create_stripe_price(product)
    Stripe::Price.create({
                           unit_amount: 900,
                           currency: "usd",
                           recurring: { interval: "month" },
                           product: product
                         })
  end

  def create_stripe_checkout_session(customer, price)
    Stripe::Checkout::Session.create(
      payment_method_types: ["card"],
      customer: customer,
      line_items: [{
        price: price,
        quantity: 1
      }],
      mode: "subscription",
      success_url: "/",
      cancel_url: "/"
    )
  end
end
