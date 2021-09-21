# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { "Test Event" }

    properties do
      %({
        "color": "Blue",
        "size": "12"
      })
    end

    api_key
  end
end
