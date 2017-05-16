class ConversationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile, except: [:index, :create]

  def index
    authorize! :access_conversations, @profile
    @conversations = @profile.conversations.includes(profiles: :avatar).includes(messages: :sender)
      .nonempty.order(updated_at: :desc)
  end

  def show
    authorize! :access_conversations, @profile
    @conversations = @profile.conversations.nonempty.includes(profiles: :avatar).order(updated_at: :desc)
    @is_hidden = !@conversations.exists?(@conversation.id)
    update_messages_read
    @messages = @conversation.messages.includes(sender: :avatar).order(:created_at)
  end

  def read
    authorize! :access_conversations, @profile
    update_messages_read
  end

  def create
    authorize! :access_conversations, @profile
    if participant = @profile.friends.find_by(id: conversation_params[:participant_id])
      unless conversation = @profile.conversation_with(participant)
        conversation = @profile.conversations.create(profiles: [participant].flatten)
        # Disconnect target profile to resubscribe to available conversations
        ActionCable.server.remote_connections.where(current_user: participant.user).disconnect
      end
      redirect_to profile_conversation_path(@profile, conversation)
    else
      redirect_to request.referrer
    end
  end

  private

  def update_messages_read
    ids = @conversation.messages.unread_incoming(@profile).ids
    @conversation.messages.unread_incoming(@profile).update_all(is_read: true)

    if ids.any?
      ConversationMessagesChannel.broadcast_to(@conversation, { update: ids })
    end
  end

  def conversation_params
    params.require(:conversation).permit(:participant_id)
  end
end
