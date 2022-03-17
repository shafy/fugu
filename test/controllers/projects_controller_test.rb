# frozen_string_literal: true

require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  def basic_setup
    @user = FactoryBot.create(:user)
    sign_in @user
  end

  def create_project
    @project = FactoryBot.create(:project, user: @user)
    @api_key_test = FactoryBot.create(:api_key, project: @project, test: true)
    @api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
  end

  class GetIndex < ProjectsControllerTest
    setup do
      basic_setup
      create_project
      get user_projects_path(@user.hash_id)
    end

    test "is succesful" do
      assert :success
    end

    test "contains created project" do
      assert_match(@project.name, @response.body)
    end
  end

  class PostCreate < ProjectsControllerTest
    setup do
      basic_setup
      @project_attributes = {
        name: "test-project"
      }
    end

    test "is succesful" do
      post user_projects_path(@user.hash_id), params: { project: @project_attributes }
      assert_redirected_to user_project_events_path(@user.hash_id,
                                                    @project_attributes[:name].parameterize)
    end

    test "contains created project" do
      post user_projects_path(@user.hash_id), params: { project: @project_attributes }
      assert_not_empty(Project.where(name: @project_attributes[:name]))
    end

    test "is not succesful" do
      @project_attributes[:name] = "Name With Space"
      post user_projects_path(@user.hash_id), params: { project: @project_attributes }
      assert :unprocessable_entity
    end
  end

  class PatchUpdate < ProjectsControllerTest
    setup do
      basic_setup
      create_project
      @new_project_attr = {
        name: "new-name",
        public: true,
        project_id: @project.id
      }
    end

    test "is succesful" do
      patch user_project_path(@user.hash_id, @project.name), params: { project: @new_project_attr }
      assert_redirected_to user_project_settings_path(@user.hash_id,
                                                      @new_project_attr[:name].parameterize)
    end

    test "not succesful with invalid name" do
      @new_project_attr[:name] = "Nope Nope$"
      patch user_project_path(@user.hash_id, @project.name), params: { project: @new_project_attr }
      assert :unprocessable_entity
    end

    test "contains updated project" do
      patch user_project_path(@user.hash_id, @project.name), params: { project: @new_project_attr }
      assert_not_empty(
        Project.where(name: @new_project_attr[:name], public: @new_project_attr[:public])
      )
    end
  end
end
