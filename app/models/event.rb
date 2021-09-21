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

  before_validation :convert_properties_to_hash

  private

  def convert_properties_to_hash
    return if properties.is_a?(Hash) || properties.nil?

    self.properties = JSON.parse(properties) if properties
  rescue StandardError
    errors.add(:properties, 'must be valid JSON')
  end
end
