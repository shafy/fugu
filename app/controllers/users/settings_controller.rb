# frozen_string_literal: true

module Users
  class SettingsController < ApplicationController
    before_action :show_not_active_flash, only: %i[show]

    def show
      return unless ENV["FUGU_CLOUD"] == "true"

      # following code is irrelevant if you're self-hosting
      return unless current_user.canceled? && current_user.stripe_customer_id.present?

      customer = retrieve_stripe_customer

      return unless customer.subscriptions.data.first

      @cancel_at = format_cancel_time(customer.subscriptions.data.first.cancel_at)
    end

    private

    def retrieve_stripe_customer
      Stripe::Customer.retrieve(
        id: current_user.stripe_customer_id,
        expand: ["subscriptions"]
      )
    end

    def format_cancel_time(unix_time)
      return unless unix_time

      Time.at(unix_time).utc.to_datetime.strftime("%b %-d, %Y")
    end
  end
end
