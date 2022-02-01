# frozen_string_literal: true

class EventsController < ApplicationController
  include ApiKeyable
  include Dateable
  include EventNameable

  before_action :set_project, only: %i[index show]
  before_action :authorize_project_user, only: %i[index show]
  before_action :set_api_key, only: %i[index show]
  before_action :set_dates, only: %i[show]
  before_action :set_event_names, only: %i[index show]
  before_action :set_selected_event, only: %i[show]
  before_action :set_property, only: %i[show]
  before_action :set_properties, only: %i[show]
  before_action :set_property_values, only: %i[show]
  before_action :set_possible_aggregations, only: %i[show]
  before_action :set_aggregation, only: %i[show]
  before_action :show_test_alert, only: %i[show]
  before_action :show_not_active_flash, only: %i[index show]

  after_action :track_event, only: %i[show]

  def index
    return render layout: "data_view" unless @event_names&.first

    redirect_to project_event_path(
      @project.name,
      @event_names.first.parameterize,
      params: { test: params[:test] }
    )
  end

  def show
    puts "yoo"
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
    @events, @total_count = Event.format_for_chart(events_array)

    render layout: "data_view"
  end

  private

  def set_selected_event
    ev = if params[:slug]
           e = params[:slug].tr("-", " ").titleize
           Event.exists?(name: e, api_key: @api_key) ? e : @event_names.first
         else
           @event_names.first
         end
    @selected_event = CGI.escapeHTML(ev) if ev
  end

  def set_properties
    @properties = Event.distinct_properties(@selected_event, @api_key.id)
  end

  def set_property
    return if !params.key?("prop") || params[:prop] == "All"

    @property = CGI.escapeHTML(params[:prop])
  end

  def set_property_values
    return if @property.blank? || @property.casecmp?("all")

    @property_values = Event.distinct_property_values(@selected_event, @api_key.id, @property)
    @property_values.map! { |p| p&.gsub(",", "\\,") }
  end

  def set_aggregation
    @aggregation = params[:agg] ? CGI.escapeHTML(params[:agg]) : "d"
    @aggregation = @possible_aggregations.first if @possible_aggregations.exclude?(@aggregation)
  end

  def set_possible_aggregations
    # order array such that .first gives default value
    @possible_aggregations = case selected_time_period_days
                             when 366..Float::INFINITY
                               %w[m y]
                             when 32...366
                               %w[w m y]
                             when 8...32
                               %w[w d]
                             when 0...8
                               %w[d]
                             end
  end

  def selected_time_period_days
    (@end_date - @start_date) / 60 / 60 / 24
  end

  def track_event
    FuguService.track("Viewed Events")
  end
end
