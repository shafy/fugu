# frozen_string_literal: true

# == Schema Information
#
# Table name: funnel_steps
#
#  id         :bigint           not null, primary key
#  event_name :string           not null
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  funnel_id  :bigint           not null
#
# Indexes
#
#  index_funnel_steps_on_funnel_id  (funnel_id)
#
# Foreign Keys
#
#  fk_rails_...  (funnel_id => funnels.id)
#

FactoryBot.define do
  factory :funnel_step do
    sequence :event_name do |n|
      "Test Event #{n}"
    end

    sequence :order do |n|
      n
    end

    funnel
  end
end
