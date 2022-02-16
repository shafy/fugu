# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  properties :jsonb
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key_id :integer          not null
#
# Indexes
#
#  index_events_on_api_key_id  (api_key_id)
#

FactoryBot.define do
  factory :event do
    sequence :name do |n|
      "Test Event #{n}"
    end

    properties do
      %({
        "color": "Blue",
        "size": "12"
      })
    end

    api_key
  end
end
