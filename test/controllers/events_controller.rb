# frozen_string_literal: true

require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  class GetIndex < EventsControllerTest
    setup do
      @user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      @api_key_test = FactoryBot.create(:api_key, project: @project, test: true)
      @api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
    end

    test "to redirect to show with live event only" do
      live_event = FactoryBot.create(:event, api_key: @api_key_live)
      sign_in user
      get project_events_path(@project.name)
      assert_redirected_to project_event_path(@project.name, live_event.name.parameterize)
    end

    test "to redirect to show with test events only" do
      test_event = FactoryBot.create(:event, api_key: api_key_test)
      sign_in user
      get project_events_path(@project.name)
      assert_redirected_to project_event_path(@project.name, test_event.name.parameterize)
    end
  end

  class GetShow < EventsControllerTest
    setup do
      user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: user)
      FactoryBot.create(:api_key, project: @project, test: true)
      api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
      @event = FactoryBot.create(:event, api_key: api_key_live)
      @event2 = FactoryBot.create(:event, api_key: api_key_live)
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
      assert_match("data-name='test-event-1'", @response.body)
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

    test "selects correct aggregation from dropdown for day" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "d", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 7d for month" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "m", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 7d for year" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "y", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 30d for week" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "w", date: "30d" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 30d for month" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "m", date: "30d" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for month" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "m", date: "6m" })
      assert_match("data-name='m'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for year" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "y", date: "6m" })
      assert_match("data-name='y'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for day" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "d", date: "6m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 12m for week" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "w", date: "12m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 12m for day" do
      get project_events_path(@project.name, @event.name.parameterize, params: { agg: "d", date: "12m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "contains correct property values in dropdown" do
      assert_match("data-name='color' >color</option>", @response.body)
    end

    test "contains correct url in event dropdown" do
      get project_events_path(@project.name, @event2.name.parameterize, params: { agg: "m", prop: "color", date: "6m" })
      path = project_event_path(@project.name, @event2.name.parameterize, params: { agg: "m", date: "6m" })
      assert_match("data-url='#{path}'", @response.body)
    end

    test "is successful for property breakdown" do
      get project_event_path(@project.name, @event2.name.parameterize, params: { p: "color" })
      assert_response :success
    end
  end
end
