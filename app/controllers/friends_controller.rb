class FriendsController < ApplicationController
  load_and_authorize_resource :profile

  def index
    @profile = @profile.decorate
    @friends = @profile.friends
    @all_count = @friends.count
    @online_count = @friends.online.count
    case @section = params[:section]
    when 'online'
      @friends = @friends.online
    end
  end
end
