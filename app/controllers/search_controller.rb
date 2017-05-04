class SearchController < ApplicationController
  def index
    @profiles = Profile.search_by_full_name(params[:q])
  end
end
