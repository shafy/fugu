# == Schema Information
#
# Table name: funnels
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  api_key_id :bigint           not null
#
# Indexes
#
#  index_funnels_on_api_key_id           (api_key_id)
#  index_funnels_on_name_and_api_key_id  (name,api_key_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (api_key_id => api_keys.id)
#

# frozen_string_literal: true

class Funnel < ApplicationRecord
  belongs_to :api_key

  has_many :funnel_steps, dependent: :destroy
  accepts_nested_attributes_for :funnel_steps,
                                reject_if: ->(attr) { attr[:event_name].blank? }

  validates :name,
            presence: true,
            uniqueness: {
              scope: :api_key_id,
              message: "You already have a funnel with this name",
              case_insensitive: true
            },
            format:
              {
                with: /\A[a-zA-Z0-9\s]*\z/,
                message: "can only contain numbers, letters and spaces"
              }

  validates :funnel_steps, presence: { message: "- Add at least one funnel step" }

  before_validation :titleize_name
  before_validation :strip_name

  FUNNEL_PARAMS = %i[user_id project_slug slug test event prop date embed].freeze

  private

  def titleize_name
    self.name = name.downcase.titleize if name
  end

  def strip_name
    self.name = name.strip if name
  end
end
