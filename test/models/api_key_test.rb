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

require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  test "has a valid factory" do
    assert build(:api_key)
  end

  context "validations" do
    subject { build(:api_key) }

    should belong_to(:project)
  end
end
