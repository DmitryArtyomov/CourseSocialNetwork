# == Schema Information
#
# Table name: conversations_profiles
#
#  profile_id      :integer          not null
#  conversation_id :integer          not null
#  id              :integer          not null, primary key
#
# Indexes
#
#  index_conversations_profiles_on_conversation_id_and_profile_id  (conversation_id,profile_id)
#  index_conversations_profiles_on_profile_id_and_conversation_id  (profile_id,conversation_id)
#

class ConversationParticipant < ApplicationRecord
  self.table_name = "conversations_profiles"

  belongs_to :conversation
  belongs_to :profile
end
