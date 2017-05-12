class ConversationsChannel < ApplicationCable::Channel
  def subscribed
    conversations = current_user.profile.conversations.each do |conversation|
      stream_for conversation, -> (message) do
        ActiveRecord::Base.connection_pool.with_connection do
          if ability.can? :read, conversation
            transmit ActiveSupport::JSON.decode(message), via: conversation
          end
        end
      end
    end
  end
end
