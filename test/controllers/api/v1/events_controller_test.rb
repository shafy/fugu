# frozen_string_literal: true

require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  class PostCreate < EventsControllerTest
    setup do
      @user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, user: @user)
      @api_key_test = FactoryBot.create(:api_key, project: project, test: true)
      @api_key_live = FactoryBot.create(:api_key, project: project, test: false)

      @name = "Test Event"
      @properties = %({
        "color": "Blue",
        "size": "12"
      })

      @event_params = {
        api_key: @api_key_live.key_value,
        name: @name,
        properties: @properties
      }
    end

    test "POST create should respond with success" do
      post api_v1_events_path, params: @event_params
      assert_response :success
    end

    test "POST create should add event" do
      assert_difference("Event.count") do
        post api_v1_events_path, params: @event_params
      end
    end

    test "POST create should create correct event" do
      post api_v1_events_path, params: @event_params
      assert_not_empty(Event.where(name: @name))
      assert_not_empty(Event.where("properties->>'color' = 'Blue'"))
    end

    test "POST create should respond with ArgumentError for name = nil" do
      @event_params[:name] = nil
      post api_v1_events_path, params: @event_params
      assert_response 422
      assert_match("'name' can't be nil", @response.body)
    end

    test "POST create should respond with ArgumentError for missing name key" do
      @event_params.delete(:name)
      post api_v1_events_path, params: @event_params
      assert_response 422
      assert_match("missing 'name' key", @response.body)
    end

    test "POST create should respond with JSON error" do
      @event_params[:properties] = "{incorrect_json: hehe}"
      post api_v1_events_path, params: @event_params
      assert_response 422
      assert_match("Properties must be valid JSON", @response.body)
    end

    test "POST create should not create event for inactive user" do
      @user.update(status: "inactive")
      assert_no_difference "Event.count" do
        post api_v1_events_path, params: @event_params
      end
    end

    test "POST create should return correct ArgumentError for inactive user" do
      @user.update(status: "inactive")
      post api_v1_events_path, params: @event_params
      assert_response 422
      assert_match("You need an active subscription", @response.body)
    end

    test "POST create should be successful for inactive user if self-hosted" do
      ENV["FUGU_CLOUD"] = "false"
      @user.update(status: "inactive")
      assert_difference "Event.count" do
        post api_v1_events_path, params: @event_params
      end
      ENV["FUGU_CLOUD"] = "true"
    end

    test "POST create should add event with test api key for inactive user" do
      @user.update(status: "inactive")
      @event_params[:api_key] = @api_key_test.key_value
      assert_difference("Event.count") do
        post api_v1_events_path, params: @event_params
      end
    end
  end
end
