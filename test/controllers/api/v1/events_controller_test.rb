# frozen_string_literal: true

require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    api_key = FactoryBot.create(:api_key)

    @name = "Test Event"
    @properties = %({
      "color": "Blue",
      "size": "12"
    })

    @event_params = {
      api_key: api_key.key_value,
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
end
