# frozen_string_literal: true

# These alerts are only used in the Fugu Cloud veresion (not imporatnt if you're self-hosting)
module InactiveAlertable
  extend ActiveSupport::Concern

  private

  def show_not_active_flash
    return unless ENV["FUGU_CLOUD"] == "true"

    flash.now[:not_active] = user_canceled_flash if current_user.canceled?
    flash.now[:not_active] = user_inactive_flash if current_user.inactive?
  end

  # rubocop:disable Rails/OutputSafety
  def user_canceled_flash
    %(
      You have canceled your subscription and it will end soon.
      Make sure to &nbsp; <a href="#{users_settings_path}">renew</a> &nbsp; it
      if you want to keep using Fugu.
    ).html_safe
  end

  def user_inactive_flash
    %(
      Hey there 👋 Make sure to&nbsp;<a href="#{users_settings_path}">subscribe</a>&nbsp;in
      order to track events.
      You can use your test API key to give Fugu a spin without a subscription.
    ).html_safe
  end
  # rubocop:enable Rails/OutputSafety
end
