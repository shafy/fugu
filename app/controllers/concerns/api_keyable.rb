# frozen_string_literal: true

module ApiKeyable
  extend ActiveSupport::Concern

  included do
    before_action :set_api_key, only: %i[index show]
  end

  private

  def set_api_key
    @api_key = params[:test] == "true" ? @project.api_key_test : @project.api_key_live
  end
end
