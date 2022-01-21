# frozen_string_literal: true

require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  class CreateUser < RegistrationsControllerTest
    setup do
      @user = FactoryBot.build(:user)
      @user_params = {
        email: @user.email,
        password: @user.password,
        password_confirmation: @user.password
      }

      post user_registration_path, params: { user: @user_params }
    end

    test "to redirect to projects overview" do
      assert_redirected_to root_path
    end

    test "creates the correct user" do
      assert_not_empty(User.where(email: @user.email))
    end
  end
end
