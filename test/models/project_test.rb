# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  public     :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_name_and_user_id  (name,user_id) UNIQUE
#  index_projects_on_user_id           (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

require "test_helper"

class ProjectTest < ActiveSupport::TestCase
  test "has a valid factory" do
    assert build(:project)
  end

  context "validations" do
    subject { build(:project) }

    should validate_presence_of(:name)

    should validate_uniqueness_of(:name)
      .scoped_to(:user_id)
      .with_message("You already have a project with this name")
      .case_insensitive

    should validate_length_of(:name).is_at_most(40)

    should belong_to(:user)

    should_not allow_value("Test Project").for(:name)
    should_not allow_values("project", "projects", "Project").for(:name)
  end

  test ".creat_api_keys should create api keys" do
    project = create(:project)
    project.create_api_keys

    assert_not_nil(ApiKey.where(project: project).first)
    assert_not_nil(ApiKey.where(project: project).second)
  end
end
