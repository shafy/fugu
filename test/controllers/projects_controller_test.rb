# frozen_string_literal: true

require "test_helper"

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  class GetIndex < ProjectsControllerTest
    setup do
      user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      sign_in user
      get projects_path
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct project name" do
      assert_match(@project.name, @response.body)
    end
  end

  class GetNew < ProjectsControllerTest
    setup do
      user = FactoryBot.create(:user)
      sign_in user
      get new_project_path
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct project name" do
      assert_match("Project name", @response.body)
    end
  end

  class GetShow < ProjectsControllerTest
    setup do
      user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      FactoryBot.create(:api_key, project: @project, test: true)
      api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
      @event = FactoryBot.create(:event, api_key: api_key_live)
      @event2 = FactoryBot.create(:event, name: "Test Event 2", api_key: api_key_live)
      sign_in user
      get project_path(@project.name)
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct project name" do
      assert_match(@project.name, @response.body)
    end

    test "contains event name" do
      assert_match(@event.name, @response.body)
    end

    test "contain correct event names in dropdown" do
      assert_match("data-name='test-event-2'>#{@event2.name}</option>", @response.body)
    end

    test "contain correct property values in dropdown" do
      assert_match("data-name='color'>color</option>", @response.body)
    end

    test "is successful for property breakdown" do
      get project_path(@project.name, p: "color")
      assert_response :success
    end
  end
end
