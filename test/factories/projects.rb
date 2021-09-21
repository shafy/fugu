# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    sequence :name do |n|
      "test-project-#{n}"
    end

    user
  end
end
