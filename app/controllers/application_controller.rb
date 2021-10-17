# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :show_not_active_flash

  private

  def show_not_active_flash
    flash.now[:not_active] = user_canceled_flash if current_user.canceled?
    flash.now[:not_active] = user_inactive_flash if current_user.inactive?
  end

  def user_canceled_flash
    "You have canceled your subscription and it will end soon."\
      " Make sure to renew it if you want to keep using Fugu."
  end

  def user_inactive_flash
    "Hey there 👋 Make sure to subscribe in order to track events."\
      " You can use your test API key to give Fugu a spin without a subscription."
  end
end
