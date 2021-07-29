# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  properties :json
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
  validate :properties_is_json

  private

  def properties_is_json
    return if properties.empty?

    return errors.add(:properties, 'must be valid JSON') unless properties.is_a?(String)

    begin
      JSON.parse(properties)
    rescue StandardError
      errors.add(:properties, 'must be valid JSON')
    end
  end
end
