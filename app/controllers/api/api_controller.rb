# frozen_string_literal: true

module Api
  class ApiController < ApplicationController
    skip_before_action :verify_authenticity_token
    around_action :handle_exceptions

    private

    def handle_exceptions
      begin
        yield
      rescue ActiveRecord::RecordNotFound => e
        @status = 404
        @error_type = e.class.to_s
        # @message = 'Record not found'
      rescue ArgumentError => e
        @status = 422
        @error_type = e.class.to_s
      rescue StandardError => e
        @status = 500
        @error_type = e.class.to_s
      end

      return if e.instance_of?(NilClass)

      render json: { error: { type: @error_type, message: e.message } },
             status: @status
    end
  end
end
