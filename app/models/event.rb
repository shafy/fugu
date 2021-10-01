# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  properties :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key_id :bigint           not null
#
# Indexes
#
#  index_events_on_api_key_id  (api_key_id)
#
# Foreign Keys
#
#  fk_rails_...  (api_key_id => api_keys.id)
#
class Event < ApplicationRecord
  belongs_to :api_key, validate: true

  validates :name, presence: true

  before_validation :convert_properties_to_hash

  def self.aggregations
    {
      "d" => "day",
      "w" => "week",
      "m" => "month",
      "y" => "year"
    }
  end

  def self.with_aggregation(name, api_key_id, agg)
    ActiveRecord::Base.connection.execute(
      with_agg_sql_query(name, api_key_id, agg)
    ).to_a
  end

  def self.distinct_properties(name)
    ActiveRecord::Base.connection.execute(
      distinct_properties_sql_query(name)
    ).map { |row| row["field"] }
  end

  # rubocop:disable Metrics/MethodLength
  def self.distinct_properties_sql_query(event_name)
    %(
      SELECT
        DISTINCT field
      FROM (
        SELECT jsonb_object_keys(properties) AS field
        FROM events
        WHERE name = '#{event_name}'
      ) AS subquery
    )
  end

  def self.with_agg_sql_query(event_name, api_key_id, aggregation)
    %(
      WITH range_values AS (
        SELECT date_trunc('#{aggregation}', min(created_at)) as minval,
               date_trunc('#{aggregation}', max(created_at)) as maxval
        FROM events
        WHERE name='#{event_name}' AND
          api_key_id=#{api_key_id} AND
          (properties->'color') IS NOT NULL
        ),

      week_range AS (
        SELECT generate_series(minval, maxval, '1 #{aggregation}'::interval) as date
        FROM range_values
      ),

      weekly_counts AS (
        SELECT date_trunc('#{aggregation}', created_at) as date,
               count(*) as count,
               properties->'color' as color
        FROM events
        WHERE name='#{event_name}' AND api_key_id=#{api_key_id}
        GROUP BY date, color
      )

      SELECT week_range.date::date,
        weekly_counts.color,
        CASE WHEN weekly_counts.count is NULL THEN 0 ELSE weekly_counts.count END AS count
      FROM week_range
      LEFT OUTER JOIN weekly_counts on week_range.date = weekly_counts.date;
    )
  end
  # rubocop:enable Metrics/MethodLength

  private

  def convert_properties_to_hash
    return if properties.is_a?(Hash) || properties.nil?

    self.properties = JSON.parse(properties) if properties
  rescue StandardError
    errors.add(:properties, 'must be valid JSON')
  end
end
