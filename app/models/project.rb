# frozen_string_literal: true

# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Project < ApplicationRecord
  has_many :events, dependent: :destroy
  has_one :api_keys, dependent: :destroy

  validates :name, presence: true

  before_save :titleize_name

  def titleize_name
    self.name = name.titleize
  end
end
