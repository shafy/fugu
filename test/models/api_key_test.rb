# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  key_value  :string           not null
#  test       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_api_keys_on_key_value   (key_value) UNIQUE
#  index_api_keys_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
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
