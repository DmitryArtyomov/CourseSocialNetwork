class MessagesController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource :conversation
  load_resource through: :conversation

  def create
    @message.sender = @profile
    authorize! :create, @message
    if @message.save
      @conversation.touch
      broadcast_message
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
    concurrent_message = @message.decorate
      .concurrent?(@conversation.messages.order(created_at: :desc).offset(1).limit(1).first)
    message_string = render_to_string(partial: 'message', layout: false, formats: [:html],
      locals: { message: @message, concurrent_message: concurrent_message })

    ConversationChannel.broadcast_to(@conversation, message_string)
  end
end
