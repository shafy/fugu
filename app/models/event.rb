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

# rubocop: disable Metrics/ClassLength
class Event < ApplicationRecord
  belongs_to :api_key, validate: true

  validates :name,
            presence: true,
            length: { maximum: 25 },
            format:
              {
                with: /\A[a-zA-Z0-9\s]*\z/,
                message: "can only contain numbers, letters and spaces"
              },
            exclusion:
              {
                in: %w[all All],
                message: "'%{value}' is a reserved event name by Fugu and can't be used"
              }

  include Inactivable

  validate :excluded_property_values
  validate :excluded_property_names
  validate :limit_property_name_length

  before_validation :convert_properties_to_hash
  before_validation :remove_whitespaces_from_name

  before_create :titleize_name
  before_create :sanitize_prop_values

  DATE_OPTIONS = {
    "1d" => "Today",
    "7d" => "Last 7 days",
    "this_m" => "This month",
    "30d" => "Last 30 days",
    "3m" => "Last 3 months",
    "6m" => "Last 6 months",
    "12m" => "Last 12 months"
  }.freeze

  AGGREGATIONS = {
    "d" => "day",
    "w" => "week",
    "m" => "month",
    "y" => "year"
  }.freeze

  IPV4_REGEX = /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
  # rubocop:disable Layout/LineLength
  IPV6_REGEX = /^\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)(\.(25[0-5]|2[0-4]\d|1\d\d|[1-9]?\d)){3}))|:)))(%.+)?\s*$/
  # rubocop:enable Layout/LineLength
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  EVENT_PARAMS = %i[project_slug slug test event prop agg date].freeze

  def self.distinct_events_names(api_key)
    Event.where(api_key: api_key).order(name: :asc).distinct.pluck(:name)
  end

  def self.format_for_chart(events_array)
    events_grouped = events_array.group_by { |e| e["property_value"] }
    total_count = 0
    events_grouped.each do |k, v|
      data = v.map { |vv| vv["count"] }
      events_grouped[k] = {
        data: data,
        total_count: data.sum
      }
      total_count += events_grouped[k][:total_count]
    end
    [events_grouped.sort_by { |k, v| [-v[:total_count], k] }.to_h, total_count]
  end

  # rubocop:disable Metrics/ParameterLists
  def self.with_aggregation(
    event_name:,
    api_key_id:,
    agg:, prop_name:,
    prop_values:,
    start_date:,
    end_date:
  )
    ActiveRecord::Base.connection.execute(
      with_agg_sql_query(
        event_name: event_name, api_key_id: api_key_id, agg: agg,
        prop_name: prop_name, prop_values: prop_values,
        start_date: start_date, end_date: end_date,
        prop_breakdown: prop_breakdown?(prop_name, prop_values)
      )
    ).to_a
  end
  # rubocop:enable Metrics/ParameterLists

  def self.distinct_properties(name, api_key_id)
    ActiveRecord::Base.connection.execute(
      distinct_properties_sql_query(name, api_key_id)
    ).map { |row| row["field"] }
  end

  def self.distinct_property_values(name, api_key_id, property)
    ActiveRecord::Base.connection.execute(
      distinct_property_values_sql_query(name, api_key_id, property)
    ).filter_map { |row| row["property"] }
  end

  def self.prop_breakdown?(prop_name, prop_values)
    prop_name.present? && !prop_name.casecmp?("all") && prop_values && prop_values.any?
  end

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

  # rubocop:disable Metrics/ParameterLists
  def self.with_agg_sql_query(
    event_name:,
    api_key_id:,
    agg:,
    prop_name:,
    prop_values:,
    start_date:,
    end_date:,
    prop_breakdown:
  )
    %(
      WITH

      interval_and_prop_range AS (
        #{interval_and_prop_range_sql(prop_values, start_date, end_date, agg, prop_breakdown)}
      ),

      interval_counts AS (
        #{interval_counts_sql(prop_name, agg, event_name, api_key_id, prop_breakdown)}
      )

      SELECT interval_and_prop_range.date::date,
        #{"interval_and_prop_range.property_value," if prop_breakdown}
        CASE WHEN interval_counts.count is NULL THEN 0 ELSE interval_counts.count END AS count
      FROM interval_and_prop_range
      LEFT OUTER JOIN interval_counts ON interval_and_prop_range.date = interval_counts.date
      #{if prop_breakdown
          " AND interval_and_prop_range.property_value = interval_counts.property_value"
        end}
      ORDER BY interval_and_prop_range.date ASC;
    )
  end
  # rubocop:enable Metrics/ParameterLists

  def self.interval_counts_sql(prop_name, agg, event_name, api_key_id, prop_breakdown)
    %(
      SELECT date_trunc('#{agg}', created_at) AS date,
              count(*) AS count
              #{", properties->>'#{prop_name}' AS property_value" if prop_breakdown}
      FROM events
      WHERE name='#{event_name}' AND api_key_id=#{api_key_id}
      GROUP BY date #{", property_value" if prop_breakdown}
    )
  end

  def self.interval_and_prop_range_sql(prop_values, start_date, end_date, agg, prop_breakdown)
    if prop_breakdown
      %(
        SELECT (
          SELECT property_val_arr[n_property_val] AS property_value
          FROM
          (
            SELECT E'{#{prop_values.map(&:inspect).join(",")}}'::text[] AS property_val_arr
          ) property_values
        ),
        #{generate_series_dates_sql(start_date, end_date, agg)}
        FROM generate_series(1,#{prop_values.length}) AS n_property_val
      )
    else
      interval_range_sql(start_date, end_date, agg)
    end
  end

  def self.interval_range_sql(start_date, end_date, agg)
    %(
      SELECT #{generate_series_dates_sql(start_date, end_date, agg)}
    )
  end

  def self.generate_series_dates_sql(start_date, end_date, agg)
    %(
      generate_series(
        date_trunc('#{agg}', '#{start_date}'::date)::date,
        date_trunc('#{agg}', '#{end_date}'::date)::date,
        '1 #{agg}'::interval
      ) as date
    )
  end

  private

  def convert_properties_to_hash
    return if properties.is_a?(Hash) || properties.nil?

    self.properties = JSON.parse(properties) if properties
  rescue StandardError
    errors.add(:properties, "must be valid JSON")
  end

  def sanitize_prop_values
    properties&.map { |k, v| properties[k] = CGI.escapeHTML(v.to_s) }
  end

  def remove_whitespaces_from_name
    self.name = name.split.join(" ") if name
  end

  def titleize_name
    self.name = name.downcase.titleize if name
  end

  def excluded_property_names
    excluded_names = %w[all email e-mail e_mail ip ip-address ip_address address phone phone-number
                        phone_number]
    return unless properties.is_a?(Hash)

    return unless properties&.keys

    return unless (properties.keys.map(&:downcase) & excluded_names).any?

    errors.add(:properties,
               "You've used a property name that's prohibited by Fugu (such as 'all')."\
               " Learn more about property constraints in the Fugu docs: https://docs.fugu.lol")
  end

  def excluded_property_values
    excluded_values = [IPV4_REGEX, IPV6_REGEX, EMAIL_REGEX]

    return unless properties.is_a?(Hash)

    return unless properties&.values

    contains_excluded_values = false
    excluded_values.each do |v|
      contains_excluded_values = properties.values.grep(v).any?
      break if contains_excluded_values
    end

    return unless contains_excluded_values

    errors.add(:properties,
               "You've used a property value that's prohibited by Fugu (such as an email address)."\
               " Learn more about property constraints in the Fugu docs: https://docs.fugu.lol")
  end

  def limit_property_name_length
    return unless properties.is_a?(Hash)

    return unless properties&.keys

    return unless properties.keys.map(&:length).any? { |l| l > 15 }

    errors.add(:properties,
               "You've used a property name that's too long (> 15 characters)."\
               " Please choose a shorter name.")
  end
end
# rubocop: enable Metrics/ClassLength
