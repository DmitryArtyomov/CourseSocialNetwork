# == Schema Information
#
# Table name: conversations
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Conversation < ApplicationRecord
  has_and_belongs_to_many :profiles
  has_many :messages

  def unread_messages_count(profile)
    messages.unread_incoming(profile).count
  end
end
