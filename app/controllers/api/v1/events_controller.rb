# frozen_string_literal: true

module Api
  module V1
    class EventsController < Api::ApiController
      before_action :validate_param_keys, only: %w[create]

      def create
        event = Event.create(
          name: params[:name],
          api_key: ApiKey.find_by!(key_value: params[:api_key]),
          properties: params[:properties]
        )

        raise ArgumentError, event.errors.full_messages.first unless event.errors.empty?

        render json: { success: true, event: event }, status: :ok
      end

      def validate_param_keys
        raise ArgumentError, "missing 'name' key" unless params.key?(:name)

        raise ArgumentError, "'name' can't be nil" if params[:name].nil?
      end
    end
  end
end
