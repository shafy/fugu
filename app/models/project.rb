# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_projects_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Project < ApplicationRecord
  has_many :api_keys, dependent: :destroy
  belongs_to :user

  validates :name, presence: true
  validates :user, presence: true

  before_save :titleize_name

  after_create :create_api_keys

  def titleize_name
    self.name = name.titleize
  end

  def create_api_keys
    ApiKey.create(project: self, test: false)
    ApiKey.create(project: self, test: true)
  end

  def api_key_live
    api_keys.find_by(test: false)
  end

  def api_key_test
    api_keys.find_by(test: true)
  end
end
