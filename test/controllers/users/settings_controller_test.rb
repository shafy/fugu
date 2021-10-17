# frozen_string_literal: true

require "test_helper"

class SettingsControllerTest < ActionDispatch::IntegrationTest
  def setup
    FactoryBot.create(:project, user: @user)
    sign_in @user
    get users_settings_path
  end

  class GetShowInactiveUser < SettingsControllerTest
    setup do
      @user = FactoryBot.create(:user)
      setup
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct email" do
      assert_match(@user.email, @response.body)
    end

    test "display correct text" do
      assert_match("You don't have an active subscription", @response.body)
    end

    test "display correct links" do
      assert_match("/stripe/checkout_session", @response.body)
      assert_match("/stripe/checkout_session", @response.body)
    end
  end

  class GetShowActiveUser < SettingsControllerTest
    setup do
      @user = FactoryBot.create(:user, status: "active")
      setup
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct text" do
      assert_match("Your Fugu subscription is active and renews monthly", @response.body)
    end

    test "display correct link" do
      assert_match("/stripe/customer_portal", @response.body)
    end
  end

  class GetShowCanceledUser < SettingsControllerTest
    setup do
      @user = FactoryBot.create(:user, status: "canceled")
      setup
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct text" do
      assert_match("Your Fugu subscription is canceled", @response.body)
    end

    test "display correct link" do
      assert_match("/stripe/customer_portal", @response.body)
    end
  end
end
