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
      @prev_message = @conversation.messages.order(created_at: :desc).offset(1).limit(1).first
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
end
