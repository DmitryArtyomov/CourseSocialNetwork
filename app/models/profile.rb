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
# Indexes
#
#  index_profiles_on_avatar_id   (avatar_id)
#  index_profiles_on_first_name  (first_name)
#  index_profiles_on_gender      (gender)
#  index_profiles_on_last_name   (last_name)
#  index_profiles_on_user_id     (user_id) UNIQUE
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

  has_many :accepted_outgoing_friend_requests, -> { accepted },   foreign_key: 'sender_id', class_name: 'FriendRequest'
  has_many :outgoing_friend_requests,          -> { unaccepted }, foreign_key: 'sender_id', class_name: 'FriendRequest'

  has_many :incoming_pending_friend_requests,  -> { pending },  foreign_key: 'recipient_id', class_name: 'FriendRequest'
  has_many :incoming_declined_friend_requests, -> { declined }, foreign_key: 'recipient_id', class_name: 'FriendRequest'

  has_many :friends, through: :accepted_outgoing_friend_requests, source: :recipient
end
