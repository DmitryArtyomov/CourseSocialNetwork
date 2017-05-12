class ConversationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile, except: :index

  def index
    authorize! :view_conversations, @profile
    @conversations = @profile.conversations.includes(profiles: :avatar).includes(messages: :sender)
      .nonempty.order(updated_at: :desc)
  end

  def show
    authorize! :view_conversations, @profile
    @conversations = @profile.conversations.includes(profiles: :avatar).includes(messages: :sender)
      .nonempty.order(updated_at: :desc)
    update_messages_read
    @messages = @conversation.messages.includes(sender: :avatar).order(:created_at)
  end

  def read
    authorize! :view_conversations, @profile
    update_messages_read
  end

  private

  def update_messages_read
    ids = @conversation.messages.unread_incoming(@profile).ids
    @conversation.messages.unread_incoming(@profile).update_all(is_read: true)

    if ids.length > 0
      messages_update = {
        update: ids
      }
      ConversationMessagesChannel.broadcast_to(@conversation, messages_update)
    end
  end
end
