class User < ApplicationRecord
  include TranslateEnum

  # Include default devise modules. Others available are:
  # :trackable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lastseenable

  enum gender: { not_shown: 0, male: 1, female: 2 }
  translate_enum :gender

  validates :first_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :gender, presence: true
  validates :date_of_birth, presence: true
end
