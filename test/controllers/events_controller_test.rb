# frozen_string_literal: true

require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  class GetIndex < EventsControllerTest
    setup do
      @user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: @user)
      @api_key_test = FactoryBot.create(:api_key, project: @project, test: true)
      @api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
    end

    test "to show index if no live events" do
      FactoryBot.create(:event, api_key: @api_key_live)
      sign_in @user
      get project_events_path(@project.name)
      # assert_redirected_to project_event_path(@project.name, live_event.name.parameterize)
      assert :success
    end

    test "to show index if no test events" do
      FactoryBot.create(:event, api_key: @api_key_test)
      sign_in @user
      get project_events_path(@project.name, params: { test: true })
      # assert_redirected_to project_event_path(@project.name, live_event.name.parameterize)
      assert :success
    end

    test "to redirect to show if events in live mode" do
      live_event = FactoryBot.create(:event, api_key: @api_key_live)
      sign_in @user
      get project_events_path(@project.name, params: { test: false })
      assert_redirected_to project_event_path(@project.name, live_event.name.parameterize,
                                              params: { test: false })
    end

    test "to redirect to show if events in test mode" do
      test_event = FactoryBot.create(:event, api_key: @api_key_test)
      sign_in @user
      get project_events_path(@project.name, params: { test: true })
      assert_redirected_to project_event_path(@project.name, test_event.name.parameterize,
                                              params: { test: true })
    end
  end

  # rubocop: disable Metrics/ClassLength
  class GetShow < EventsControllerTest
    def setup_live_events
      @event = FactoryBot.create(:event, api_key: @api_key_live)
      @event2 = FactoryBot.create(:event, api_key: @api_key_live)
    end

    setup do
      @user = FactoryBot.create(:user)
      @project = FactoryBot.create(:project, user: @user)
      @api_key_test = FactoryBot.create(:api_key, project: @project, test: true)
      @api_key_live = FactoryBot.create(:api_key, project: @project, test: false)
    end

    test "be successful" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_response :success
    end

    test "to redirect to index if no event with this name (test mode)" do
      live_event = FactoryBot.create(:event, api_key: @api_key_live)
      sign_in @user
      get project_event_path(@project.name, live_event.name.parameterize, params: { test: true })
      assert_redirected_to project_events_path(@project.name, params: { test: true })
    end

    test "to redirect to index if no event with this name (live mode)" do
      test_event = FactoryBot.create(:event, api_key: @api_key_test)
      sign_in @user
      get project_event_path(@project.name, test_event.name.parameterize, params: { test: false })
      assert_redirected_to project_events_path(@project.name, params: { test: false })
    end

    test "display correct project name" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_match(@project.name, @response.body)
    end

    test "contain correct event names in dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_match("data-name='#{@event.name.parameterize}'", @response.body)
      assert_match("data-name='#{@event2.name.parameterize}'", @response.body)
    end

    test "selects correct event from dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_match("data-name='#{@event.name.parameterize}' selected", @response.body)
    end

    test "selects correct propery value from dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize, params: { prop: "color" })
      assert_match("data-name='color' selected", @response.body)
    end

    test "selects correct date from dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize, params: { date: "30d" })
      assert_match("data-name='30d' selected", @response.body)
    end

    test "selects correct date range when none is selected" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_match("data-name='7d' selected", @response.body)
    end

    test "selects correct date range when unvalid param is set in url" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize, params: { date: "blabla" })
      assert_match("data-name='7d' selected", @response.body)
    end

    test "selects correct possible aggregation for 1d for day" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "d", date: "1d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 7d for day" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "d", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 7d for month" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "m", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 7d for year" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "y", date: "7d" })
      assert_match("data-name='d'  selected", @response.body)
    end

    test "selects correct possible aggregation for 30d for week" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "w", date: "30d" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 30d for month" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "m", date: "30d" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 3m for month" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "m", date: "3m" })
      assert_match("data-name='m'  selected", @response.body)
    end

    test "selects correct possible aggregation for 3m for year" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "y", date: "3m" })
      assert_match("data-name='y'  selected", @response.body)
    end

    test "selects correct possible aggregation for 3m for day" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "d", date: "3m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for month" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "m", date: "6m" })
      assert_match("data-name='m'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for year" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "y", date: "6m" })
      assert_match("data-name='y'  selected", @response.body)
    end

    test "selects correct possible aggregation for 6m for day" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "d", date: "6m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 12m for week" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "w", date: "12m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "selects correct possible aggregation for 12m for day" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize,
                             params: { agg: "d", date: "12m" })
      assert_match("data-name='w'  selected", @response.body)
    end

    test "contains correct property values in dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event.name.parameterize)
      assert_match("data-name='color' >color</option>", @response.body)
    end

    test "contains correct url in event dropdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event2.name.parameterize,
                             params: { agg: "m", prop: "color", date: "6m" })
      path = project_event_path(@project.name, @event2.name.parameterize,
                                params: { agg: "m", date: "6m" })
      assert_match("data-url='#{path}'", @response.body)
    end

    test "is successful for property breakdown" do
      setup_live_events
      sign_in @user
      get project_event_path(@project.name, @event2.name.parameterize, params: { p: "color" })
      assert_response :success
    end
  end
  # rubocop:enable Metrics/ClassLength
end
