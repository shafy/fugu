# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_projects_on_name_and_user_id  (name,user_id) UNIQUE
#  index_projects_on_user_id           (user_id)
#

FactoryBot.define do
  factory :project do
    sequence :name do |n|
      "test-project-#{n}"
    end

    user
  end
end
