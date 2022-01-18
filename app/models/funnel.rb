# == Schema Information
#
# Table name: funnels
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  api_key_id :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_funnels_on_api_key_id  (api_key_id)
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

  FUNNEL_PARAMS = %i[project_slug slug test event prop date].freeze

  private

  def titleize_name
    self.name = name.downcase.titleize if name
  end

  def strip_name
    self.name = name.strip if name
  end
end
