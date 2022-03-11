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

require "test_helper"

class FunnelStepTest < ActiveSupport::TestCase
  test "has a valid factory" do
    assert build(:funnel_step)
  end

  context "validations" do
    subject { build(:funnel_step) }

    should validate_presence_of(:event_name)

    should belong_to(:funnel)
  end
end
