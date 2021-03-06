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
  include PgSearch

  belongs_to :user, optional: true

  enum gender: { not_shown: 0, male: 1, female: 2 }
  translate_enum :gender

  validates :first_name, :last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :gender, :date_of_birth, presence: true

  has_many :albums
  has_many :photos, through: :albums
  belongs_to :avatar, class_name: 'Photo', optional: true


  has_many :friend_requests, foreign_key: 'sender_id', class_name: 'FriendRequest'

  with_options foreign_key: 'sender_id', class_name: 'FriendRequest' do
    has_many :outgoing_accepted_friend_requests,   -> { accepted }
    has_many :outgoing_unaccepted_friend_requests, -> { unaccepted }
  end

  with_options foreign_key: 'recipient_id', class_name: 'FriendRequest' do
    has_many :incoming_accepted_friend_requests,   -> { accepted }
    has_many :incoming_unaccepted_friend_requests, -> { unaccepted }
    has_many :incoming_pending_friend_requests,    -> { pending }
    has_many :incoming_declined_friend_requests,   -> { declined }
  end

  has_many :out_friends, through: :outgoing_accepted_friend_requests, source: :recipient
  has_many :in_friends, through: :incoming_accepted_friend_requests, source: :sender

  def friends
    in_friends.union(out_friends).order(:updated_at)
  end

  def accepted_friend_request_with(profile)
    (
      [ outgoing_accepted_friend_requests.find { |fr| fr.recipient_id == profile.id } ] <<
      incoming_accepted_friend_requests.find { |fr| fr.sender_id == profile.id }
    ).compact.first
  end

  def out_unaccepted_request_with(profile)
    outgoing_unaccepted_friend_requests.find{ |req| req.recipient_id == profile.id }
  end

  def in_unaccepted_request_with(profile)
    incoming_unaccepted_friend_requests.find{ |req| req.sender_id == profile.id }
  end

  def incoming_requests
    incoming_pending_friend_requests
      .order(:updated_at)
      .union(incoming_declined_friend_requests.order(:updated_at))
  end

  def conversation_with(profile)
    conversations
      .joins(:profiles)
      .where(profiles: {id: profile})
      .group('conversations.id')
      .having('count(conversations.id) = ?', 1)
      .first
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  scope :online, -> {
    joins(:user).merge(User.where("last_seen > ?", Time.now - 10.minutes))
  }

  pg_search_scope :search_by_full_name, against: [:first_name, :last_name], using: { tsearch: { prefix: true } }

  has_and_belongs_to_many :conversations
end
