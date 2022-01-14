# frozen_string_literal: true

module EventNameable
  extend ActiveSupport::Concern

  private

  def set_event_names
    @event_names = Event.distinct_events_names(@api_key)
  end
end
