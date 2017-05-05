class FriendsController < ApplicationController
  load_and_authorize_resource :profile

  def index
    @profile = @profile.decorate
    @all_count = @profile.friends.count
    @online_count = @profile.friends.online.count
    case @section = params[:section]
    when 'online'
      @friends = @profile.friends.online.includes(:user, :avatar)
    else
      @friends = @profile.friends.includes(:user, :avatar)
    end
  end
end
