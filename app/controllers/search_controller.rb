class SearchController < ApplicationController
  def index
    @profiles = Profile.search_by_full_name(params[:q]).includes(:user, :avatar)
  end
end
