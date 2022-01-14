# frozen_string_literal: true

module ApiKeyable
  extend ActiveSupport::Concern

  private

  def set_api_key
    @api_key = params[:test] == "true" ? @project.api_key_test : @project.api_key_live
  end
end
