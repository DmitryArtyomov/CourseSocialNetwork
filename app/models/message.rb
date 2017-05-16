# == Schema Information
#
# Table name: messages
#
#  id              :integer          not null, primary key
#  text            :text
#  is_read         :boolean          default("false")
#  sender_id       :integer
#  conversation_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_messages_on_conversation_id  (conversation_id)
#  index_messages_on_sender_id        (sender_id)
#

class Message < ApplicationRecord
  belongs_to :sender, class_name: "Profile", foreign_key: "sender_id"
  belongs_to :conversation

  validates :sender, :conversation, :text, presence: true

  scope :unread_incoming, -> (profile_id) { where.not(sender_id: profile_id).where(is_read: false) }
  scope :unread_outgoing, -> (profile_id) { where(sender_id: profile_id).where(is_read: false) }
end
