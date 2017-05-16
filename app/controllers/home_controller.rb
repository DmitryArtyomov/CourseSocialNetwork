class HomeController < ApplicationController
  def index
    redirect_to profile_path(current_profile) if user_signed_in?
  end
end
