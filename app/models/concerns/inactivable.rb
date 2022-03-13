# frozen_string_literal: true

# This validation is only run for the Fugu Cloud version (does not apply for self-hosting)
module Inactivable
  extend ActiveSupport::Concern

  included do
    validate :user_cannot_be_inactive, if: -> { ENV["FUGU_CLOUD"] == "true" }
  end

  private

  def user_cannot_be_inactive
    return unless api_key

    return unless !api_key.test && api_key.project.user.inactive?

    errors.add(:base, "You need an active subscription to capture events with your live API key")
  end
end
