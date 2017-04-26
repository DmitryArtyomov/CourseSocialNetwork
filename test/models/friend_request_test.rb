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

require 'test_helper'

class FriendRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
