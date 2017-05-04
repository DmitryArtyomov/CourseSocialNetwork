# == Schema Information
#
# Table name: friend_requests
#
#  id           :integer          not null, primary key
#  sender_id    :integer
#  recipient_id :integer
#  status       :integer          default("0")
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_friend_requests_on_recipient_id                (recipient_id)
#  index_friend_requests_on_recipient_id_and_status     (recipient_id,status)
#  index_friend_requests_on_sender_id                   (sender_id)
#  index_friend_requests_on_sender_id_and_recipient_id  (sender_id,recipient_id) UNIQUE
#  index_friend_requests_on_sender_id_and_status        (sender_id,status)
#

class FriendRequest < ApplicationRecord
  include TranslateEnum

  belongs_to :sender, class_name: 'Profile'
  belongs_to :recipient, class_name: 'Profile'

  validates_presence_of :sender, :recipient
  validates :sender, uniqueness: { scope: :recipient }
  validate :cannot_add_self

  enum status: { pending: 0, accepted: 1, declined: 2 }
  translate_enum :status

  scope :unaccepted, -> { where.not(status: :accepted) }

  def reverse!
    self.sender_id, self.recipient_id = recipient_id, sender_id
    self.status = :declined
    self.save
  end

  def reverse?
    self.class.exists?(sender: recipient, recipient: sender)
  end

  def reverse
    self.class.find_by(sender: recipient, recipient: sender)
  end

  private

  def cannot_add_self
    errors.add(:recipient, 'You cannot add yourself as a friend') if sender == recipient
  end
end
