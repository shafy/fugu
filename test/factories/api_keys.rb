# frozen_string_literal: true
# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  key_value  :string           not null
#  project_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  test       :boolean          default("false")
#
# Indexes
#
#  index_api_keys_on_key_value   (key_value) UNIQUE
#  index_api_keys_on_project_id  (project_id)
#

FactoryBot.define do
  factory :api_key do
    sequence :key_value do |n|
      "12345678kjdhfdsa-#{n}"
    end

    project
  end
end
