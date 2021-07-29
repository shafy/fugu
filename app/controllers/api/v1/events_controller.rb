# frozen_string_literal: true

class Api::V1::EventsController < Api::ApiController
  def create
    event = Event.create(
      name: params[:name].titleize,
      api_key: ApiKey.find_by!(key_value: params[:api_key]),
      properties: params[:properties]
    )

    if event.errors.empty?
      render json: { success: true, event: event }, status: :ok
    else
      render json: {
        success: false,
        error: event.errors.full_messages.first
      }, status: :unprocessable_entity
    end
  end
end
