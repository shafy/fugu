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

require "test_helper"

class FunnelStepTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
