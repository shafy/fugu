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
  accepts_nested_attributes_for :funnel_steps
  
  validates :name,
            presence: true,
            uniqueness: {
              scope: :api_key,
              message: "You already have a funnel with this name",
              case_insensitive: true
            },
            format:
              {
                with: /\A[a-zA-Z0-9-]*\z/,
                message: "can only contain numbers, letters and hyphens"
              }
end
