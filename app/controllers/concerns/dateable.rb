# frozen_string_literal: true

module Dateable
  extend ActiveSupport::Concern

  included do
    before_action :set_dates, only: %i[show]
  end

  private

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
end
