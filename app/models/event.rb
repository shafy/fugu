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

  def self.with_aggregation(name, api_key_id, agg, prop_name, prop_values, start_date, end_date)
    ActiveRecord::Base.connection.execute(
      with_agg_sql_query(name, api_key_id, agg, prop_name, prop_values, start_date, end_date)
    ).to_a
  end

  def self.distinct_properties(name, api_key_id)
    ActiveRecord::Base.connection.execute(
      distinct_properties_sql_query(name, api_key_id)
    ).map { |row| row["field"] }
  end

  def self.distinct_property_values(name, api_key_id, property)
    ActiveRecord::Base.connection.execute(
      distinct_property_values_sql_query(name, api_key_id, property)
    ).map { |row| row["property"] }
  end

  # rubocop:disable Metrics/MethodLength
  def self.distinct_properties_sql_query(event_name, api_key_id)
    %(
      SELECT
        DISTINCT field
      FROM (
        SELECT jsonb_object_keys(properties) AS field
        FROM events
        WHERE name = '#{event_name}' AND api_key_id=#{api_key_id}
      ) AS subquery
    )
  end

  def self.distinct_property_values_sql_query(event_name, api_key_id, property)
    %(
      SELECT DISTINCT properties->>'#{property}' as property
      FROM events
      WHERE name = '#{event_name}' AND api_key_id=#{api_key_id}
    )
  end

  def self.with_agg_sql_query(event_name, api_key_id, aggregation, prop_name, prop_values, start_date, end_date)
    %(
      WITH

      week_and_prop_range AS (
        SELECT (
          SELECT property_val_arr[n_property_val] AS property_value
          FROM
          (
            SELECT '{#{prop_values}}'::text[] AS property_val_arr
          ) property_values
        ),
        generate_series(
          '#{start_date}'::date,
          '#{end_date}'::date,
          '1 #{aggregation}'::interval
        ) as date
        FROM generate_series(1,2) AS n_property_val
      ),

      weekly_counts AS (
        SELECT date_trunc('#{aggregation}', created_at) AS date,
               count(*) AS count,
               properties->>'#{prop_name}' AS property_value
        FROM events
        WHERE name='#{event_name}' AND api_key_id=#{api_key_id}
        GROUP BY date, property_value
      )

      SELECT week_and_prop_range.date::date,
        week_and_prop_range.property_value,
        CASE WHEN weekly_counts.count is NULL THEN 0 ELSE weekly_counts.count END AS count
      FROM week_and_prop_range
      LEFT OUTER JOIN weekly_counts ON week_and_prop_range.date = weekly_counts.date AND
      week_and_prop_range.property_value = weekly_counts.property_value
      ORDER BY week_and_prop_range.date ASC;
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
