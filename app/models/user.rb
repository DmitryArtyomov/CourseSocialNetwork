# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  last_seen              :datetime
#

class User < ApplicationRecord
  # include TranslateEnum

  # Include default devise modules. Others available are:
  # :trackable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lastseenable

  # enum gender: { not_shown: 0, male: 1, female: 2 }
  # translate_enum :gender

  has_one :profile, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :profile
end
