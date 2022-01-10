# frozen_string_literal: true
# == Schema Information
#
# Table name: api_keys
#
#  id         :integer          not null, primary key
#  key_value  :string           not null
#  project_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  test       :boolean          default("false")
#
# Indexes
#
#  index_api_keys_on_key_value   (key_value) UNIQUE
#  index_api_keys_on_project_id  (project_id)
#

class ApiKey < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :funnels, dependent: :destroy

  belongs_to :project, validate: true

  validates :key_value, presence: true, uniqueness: true

  before_validation :generate_key

  def generate_key
    self.key_value ||= SecureRandom.hex
  end
end
