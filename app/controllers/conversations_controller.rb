class ConversationsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile, except: :index

  def index
    authorize! :view_conversations, @profile
    @conversations = @profile.conversations.includes(profiles: :avatar)
  end

  def show
    @conversations = @profile.conversations.includes(profiles: :avatar)
    @conversation.messages.unread_incoming(@profile).update_all(is_read: true)
    @messages = @conversation.messages.includes(sender: :avatar)
  end
end
