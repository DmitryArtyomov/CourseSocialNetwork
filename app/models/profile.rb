class Profile < ApplicationRecord
  include TranslateEnum

  belongs_to :user, optional: true

  enum gender: { not_shown: 0, male: 1, female: 2 }
  translate_enum :gender

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :gender, :date_of_birth, presence: true

  has_many :photos
end
