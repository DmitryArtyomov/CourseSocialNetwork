class MessagesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource :conversation
  load_resource through: :conversation

  def create
    @message.sender = @profile
    @conversation = @conversation.decorate
    authorize! :create, @message
    if @message.save
      @conversation.touch
      broadcast_message
      broadcast_conversation
      respond_to do |format|
        format.html { redirect_to profile_conversation_path(@profile, @conversation), notice: 'Message successfully sent.' }
        format.js   { }
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def broadcast_message
    is_concurrent = @message.decorate.concurrent?(
      @conversation.messages.order(created_at: :desc).offset(1).limit(1).first
    )

    message = {
      message: render_to_string(partial: 'message', layout: false, formats: [:html],
        locals: { message: @message, is_concurrent: is_concurrent })
    }

    ConversationMessagesChannel.broadcast_to(@conversation, message)
  end

  def broadcast_conversation
    conversation_update = {
      conversation_id: @conversation.id,
      conversation_name: @message.sender.decorate.full_name,
      conversation_avatar: @message.sender.avatar ? @message.sender.avatar.image.url : ActionController::Base.helpers.image_url('no-avatar.png'),
      sender_id: @message.sender_id,
      sender: @message.sender.first_name.capitalize,
      text: @message.text,
      date: @message.created_at
    }
    ConversationsChannel.broadcast_to(@conversation, conversation_update)
  end
end
