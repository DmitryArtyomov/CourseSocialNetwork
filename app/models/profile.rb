# == Schema Information
#
# Table name: profiles
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  first_name    :string
#  last_name     :string
#  date_of_birth :datetime
#  gender        :integer
#  avatar_id     :integer
#

class Profile < ApplicationRecord
  include TranslateEnum

  belongs_to :user, optional: true

  enum gender: { not_shown: 0, male: 1, female: 2 }
  translate_enum :gender

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :gender, :date_of_birth, presence: true

  has_many :photos
  belongs_to :avatar, class_name: 'Photo', optional: true
end
