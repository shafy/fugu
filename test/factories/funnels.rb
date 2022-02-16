# frozen_string_literal: true

# == Schema Information
#
# Table name: funnels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  api_key_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_funnels_on_api_key_id           (api_key_id)
#  index_funnels_on_name_and_api_key_id  (name,api_key_id) UNIQUE
#

FactoryBot.define do
  factory :funnel do
    sequence :name do |n|
      "My Funnel #{n}"
    end
    api_key

    before(:create) do |funnel|
      funnel.funnel_steps = build_list(:funnel_step, 5, funnel: funnel)
    end
  end
end
