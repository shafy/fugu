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

require "test_helper"

class FunnelTest < ActiveSupport::TestCase
  test "has a valid factory" do
    assert build(:funnel)
  end

  context "validations" do
    subject { build(:funnel) }

    should validate_presence_of(:name)

    should validate_uniqueness_of(:name)
      .scoped_to(:api_key_id)
      .with_message("You already have a funnel with this name")
      .case_insensitive

    should belong_to(:api_key)

    should_not allow_value("My $$$").for(:name)

    should accept_nested_attributes_for(:funnel_steps)

    should have_many(:funnel_steps)
  end
end
