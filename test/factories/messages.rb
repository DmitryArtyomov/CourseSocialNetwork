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

FactoryGirl.define do
  factory :message do
    text "MyText"
    sender nil
    conversation nil
  end
end
