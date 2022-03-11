# frozen_string_literal: true

# == Schema Information
#
# Table name: funnels
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key_id :bigint           not null
#
# Indexes
#
#  index_funnels_on_api_key_id           (api_key_id)
#  index_funnels_on_name_and_api_key_id  (name,api_key_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (api_key_id => api_keys.id)
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
