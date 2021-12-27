# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_project, only: %i[index]
  before_action :authorize_project_user, only: %i[show]
  before_action :show_test_alert, only: %i[index]
  before_action :show_not_active_flash, only: %i[index]

  include Analyzable

  after_action :track_event, only: %i[show]

  def index
    return unless @selected_event

    events_array = Event.with_aggregation(
      event_name: @selected_event,
      api_key_id: @api_key.id,
      agg: Event::AGGREGATIONS[@aggregation],
      prop_name: @property,
      prop_values: @property_values,
      start_date: @start_date,
      end_date: @end_date
    )

    @dates = events_array.uniq { |e| e["date"] }.map { |d| d["date"] }
    @events = Event.format_for_chart(events_array)
  end

  private

  def track_event
    FuguService.track("Viewed Events")
  end
end
