# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "#{n}@fugu.lol"
    end

    password { 'secure_password' }
  end
end
