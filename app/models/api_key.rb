# frozen_string_literal: true

# == Schema Information
#
# Table name: api_keys
#
#  id         :bigint           not null, primary key
#  key_value  :string           not null
#  test       :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :bigint           not null
#
# Indexes
#
#  index_api_keys_on_key_value   (key_value) UNIQUE
#  index_api_keys_on_project_id  (project_id)
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class ApiKey < ApplicationRecord
  has_many :events, dependent: :destroy
  belongs_to :project, validate: true

  validates :key_value, presence: true, uniqueness: true

  before_validation :generate_key

  def generate_key
    self.key_value ||= SecureRandom.hex
  end
end
