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
#  index_friend_requests_on_recipient_id             (recipient_id)
#  index_friend_requests_on_recipient_id_and_status  (recipient_id,status)
#  index_friend_requests_on_sender_id                (sender_id)
#  index_friend_requests_on_sender_id_and_status     (sender_id,status)
#

class FriendRequest < ApplicationRecord
  include TranslateEnum

  belongs_to :sender, class_name: 'Profile'
  belongs_to :recipient, class_name: 'Profile'

  enum status: { pending: 0, accepted: 1, declined: 2 }
  translate_enum :status

  scope :unaccepted, -> { where.not(status: :accepted) }
end
