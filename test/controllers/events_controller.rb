# frozen_string_literal: true

require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  class GetIndex < EventsControllerTest
    setup do
      user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      FactoryBot.create(:api_key, project: @project, test: true)
      api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
      @event = FactoryBot.create(:event, api_key: api_key_live)
      sign_in user
      get project_events_path(@project.name)
    end

    test "to redirect correctly" do
      assert_redirected_to project_event_path(@project.name, @event.name.parameterize)
    end
  end

  class GetShow < EventsControllerTest
    setup do
      user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      FactoryBot.create(:api_key, project: @project, test: true)
      api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
      @event = FactoryBot.create(:event, api_key: api_key_live)
      @event2 = FactoryBot.create(:event, name: "Test Event 2", api_key: api_key_live)
      sign_in user
      get project_event_path(@project.name, @event.name.parameterize)
    end

    test "be successful" do
      assert_response :success
    end

    test "display correct project name" do
      assert_match(@project.name, @response.body)
    end

    test "contain correct event names in dropdown" do
      assert_match("data-name='test-event'", @response.body)
      assert_match("data-name='test-event-2'", @response.body)
    end

    test "selects correct event from dropdown" do
      get project_event_path(@project.name, "test-event-2")
      assert_match("data-name='test-event-2' selected", @response.body)
    end

    test "selects correct propery value from dropdown" do
      get project_event_path(@project.name, @event.name.parameterize, params: { prop: "color" })
      assert_match("data-name='color' selected", @response.body)
    end

    test "selects correct date from dropdown" do
      get project_event_path(@project.name, @event.name.parameterize, params: { date: "30d" })
      assert_match("data-name='30d' selected", @response.body)
    end

    test "selects correct aggregation from dropdown" do
      get project_event_path(@project.name, @event.name.parameterize, params: { agg: "m" })
      assert_match("data-name='m'  selected", @response.body)
    end

    test "contains correct property values in dropdown" do
      assert_match("data-name='color' >color</option>", @response.body)
    end

    test "contains correct url in event dropdown" do
      get project_events_path(@project.name, params: { agg: "m", prop: "color", date: "6m" })
      path = project_event_path(@project.name, @event2.name.parameterize, params: { agg: "m", date: "6m" })
      puts path
      assert_match("data-url='#{path}'", @response.body)
    end

    test "is successful for property breakdown" do
      get project_event_path(@project.name, @event2.name.parameterize, params: { p: "color" })
      assert_response :success
    end
  end
end
