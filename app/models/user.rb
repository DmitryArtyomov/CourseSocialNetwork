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
