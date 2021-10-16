# frozen_string_literal: true

require "test_helper"
require "stripe_mock"

class StripeControllerTest < ActionDispatch::IntegrationTest
  class PostWebhooksUpdateCancel < StripeControllerTest
    # customer cancels subscription for end of billing cycle
    setup do
      @user = FactoryBot.create(:user, status: "active", stripe_customer_id: "abc1")
      event = customer_subscription_updated(true, @user.stripe_customer_id)
      post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
    end

    test "be successful" do
      assert_response :success
    end

    test "sets account to canceled" do
      assert_equal(User.find(@user.id).status, "canceled")
    end
  end

  class PostWebhooksUpdateCanceled < StripeControllerTest
    # subscription is canceled at the end of billing cycle
    setup do
      @user = FactoryBot.create(:user, status: "canceled", stripe_customer_id: "abc1")
      event = customer_subscription_deleted(@user.stripe_customer_id)
      post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
    end

    test "be successful" do
      assert_response :success
    end

    test "sets account to inactive" do
      assert_equal(User.find(@user.id).status, "inactive")
    end
  end

  class PostWebhooksReactivates < StripeControllerTest
    # customer reactivates previously canceled subscription before end of billing cycle
    setup do
      @user = FactoryBot.create(:user, status: "canceled", stripe_customer_id: "abc1")
      event = customer_subscription_updated(false, @user.stripe_customer_id)
      post stripe_webhooks_path, params: event, headers: stripe_headers(event), as: :json
    end

    test "be successful" do
      assert_response :success
    end

    test "sets account to active" do
      assert_equal(User.find(@user.id).status, "active")
    end
  end

  class GetSuccessCallback < StripeControllerTest
    # customer reactivates previously canceled subscription before end of billing cycle
    setup do
      StripeMock.start
      customer = create_stripe_customer
      product = create_stripe_product
      price = create_stripe_price(product.id)
      session = create_stripe_checkout_session(customer.id, price.id)
      @user = FactoryBot.create(:user, status: "inactive", stripe_customer_id: customer.id)

      sign_in @user
      get stripe_success_callback_path, params: { session_id: session.id }
    end

    teardown { StripeMock.stop }

    test "be successful" do
      assert_response :redirect
    end

    test "sets account to active" do
      assert_equal(User.find(@user.id).status, "active")
    end
  end
end
