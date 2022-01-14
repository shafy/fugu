# == Schema Information
#
# Table name: funnel_steps
#
#  id         :integer          not null, primary key
#  event_name :string           not null
#  funnel_id  :integer          not null
#  order      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_funnel_steps_on_funnel_id  (funnel_id)
#

# frozen_string_literal: true

class FunnelStep < ApplicationRecord
  belongs_to :funnel

  validates :event_name, presence: true
end
