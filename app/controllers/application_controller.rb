# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  private

  def show_not_active_flash
    flash.now[:not_active] = user_inactive_flash
    flash.now[:not_active] = user_canceled_flash if current_user.canceled?
    flash.now[:not_active] = user_inactive_flash if current_user.inactive?
  end

  def user_canceled_flash
    %(
      You have canceled your subscription and it will end soon.
      Make sure to &nbsp; <a href="#{users_settings_path}">renew</a> &nbsp; it if you want to keep using Fugu.
    ).html_safe
  end

  def user_inactive_flash
    %(
      Hey there 👋 Make sure to&nbsp;<a href="#{users_settings_path}">subscribe</a>&nbsp;in order to track events.
      You can use your test API key to give Fugu a spin without a subscription.
    ).html_safe
  end
end
