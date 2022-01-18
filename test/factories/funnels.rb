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
#  index_funnels_on_api_key_id  (api_key_id)
#

FactoryBot.define do
  factory :funnel do
    name { "My Funnel" }
    api_key
  end
end
