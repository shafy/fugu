# frozen_string_literal: true

class Api::ApiController < ApplicationController

  skip_before_action :verify_authenticity_token
  #before_action :authorize_request
  around_action :handle_exceptions

  # def authorize_request
  #   token = UserAuthorizationService.new(request.headers).authenticate_request!
  #   # set auth0_id
  #   @auth0_id = token[0]["sub"]
  # rescue JWT::VerificationError, JWT::DecodeError
  #   render json: { error: 'Not Authenticated' }, status: :unauthorized
  # end

  private

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def handle_exceptions
    begin
      yield
    rescue ActiveRecord::RecordNotFound => e
      @status = 404
      @error_type = e.class.to_s
      #@message = 'Record not found'
    rescue ActiveRecord::RecordInvalid => e
      @status = 500
      @error_type = e.class.to_s
    rescue ArgumentError => e
      @status = 422
      @error_type = e.class.to_s
    rescue StandardError => e
      @status = 500
      @error_type = e.class.to_s
    end

    render json: {error: {type: @error_type, message: e.message }}, status: @status unless e.class == NilClass
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end