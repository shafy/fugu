# frozen_string_literal: true

module Analyzable
  extend ActiveSupport::Concern

  included do
    before_action :set_api_key, only: %i[index]
    before_action :set_event_names, only: %i[index]
    before_action :set_selected_event, only: %i[index]
    before_action :set_dates, only: %i[index]
    before_action :set_property, only: %i[index]
    before_action :set_properties, only: %i[index]
    before_action :set_property_values, only: %i[index]
    before_action :set_possible_aggregations, only: %i[show]
    before_action :set_aggregation, only: %i[index]
  end

  private

  def set_api_key
    @api_key = params[:test] == "true" ? @project.api_key_test : @project.api_key_live
  end

  def set_event_names
    @event_names = Event.where(api_key: @api_key).order(name: :asc).distinct.pluck(:name)
  end

  def set_dates
    @start_date = case params[:date]
                  when "30d"
                    29.days.ago
                  when "this_m"
                    Time.zone.now.beginning_of_month
                  when "6m"
                    6.months.ago
                  when "12m"
                    12.months.ago
                  else
                    6.days.ago
                  end
    @end_date = Time.zone.now
  end

  def set_properties
    @properties = Event.distinct_properties(@selected_event, @api_key.id)
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

  def set_property
    return if !params.key?("prop") || params[:prop] == "All"

    @property = CGI.escapeHTML(params[:prop])
  end

  def set_property_values
    return if @property.blank? || @property.casecmp?("all")

    @property_values = Event.distinct_property_values(@selected_event, @api_key.id, @property)
    @property_values.map! { |p| p&.gsub(",", "\\,") }
  end

  def selected_time_period_days
    (@end_date - @start_date) / 60 / 60 / 24
  end

  def set_selected_event
    ev = if params[:event]
           e = params[:event].tr("-", " ").titleize
           Event.exists?(name: e, api_key: @api_key) ? e : @event_names.first
         else
           @event_names.first
         end
    @selected_event = CGI.escapeHTML(ev) if ev
  end
end
