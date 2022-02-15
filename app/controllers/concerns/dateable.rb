# frozen_string_literal: true

module Dateable
  extend ActiveSupport::Concern

  private

  def set_dates
    @date_range = params[:date] ? CGI.escapeHTML(params[:date]) : "7d"
    @date_range = "7d" if Event::DATE_OPTIONS.exclude?(params[:date])
    @start_date = case @date_range
                  when "30d"
                    29.days.ago
                  when "this_m"
                    Time.zone.now.beginning_of_month
                  when "6m"
                    6.months.ago
                  when "3m"
                    3.months.ago
                  when "12m"
                    12.months.ago
                  when "7d"
                    6.days.ago
                  else
                    Time.zone.now
                  end
    @end_date = Time.zone.now
  end
end
