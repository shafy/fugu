# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  status                 :integer          default("inactive"), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  hash_id                :string           not null
#  stripe_customer_id     :string
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_hash_id               (hash_id) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  has_many :projects, dependent: :destroy

  validates :hash_id, presence: true, allow_blank: false

  enum status: {
    inactive: 0,
    active: 1,
    canceled: 2
  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  before_validation :add_hash_id, on: :create

  def add_hash_id
    # generate random hash_id for the user before being created
    return if hash_id.present?

    hash = SecureRandom.alphanumeric(4).downcase
    unless User.exists?(hash_id: hash)
      self.hash_id = hash
      return
    end
    add_hash_id
  end
end
