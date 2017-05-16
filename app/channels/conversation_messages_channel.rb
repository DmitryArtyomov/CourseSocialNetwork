class ConversationMessagesChannel < ApplicationCable::Channel
  def subscribed
    conversation = Conversation.find(params[:id])
    stream_for conversation, -> (message) do
      ActiveRecord::Base.connection_pool.with_connection do
        if ability.can? :read, conversation
          transmit ActiveSupport::JSON.decode(message), via: conversation
        end
      end
    end
  end
end
