# frozen_string_literal: true

module Dateable
  extend ActiveSupport::Concern

  private

  def set_dates
    # defaults to 7days if no date selected or if url param not in the list
    @start_date = case params[:date] ? CGI.escapeHTML(params[:date]) : "7d"
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
                  when "1d"
                    Time.zone.now
                  else
                    6.days.ago
                  end
    @end_date = Time.zone.now
  end
end
