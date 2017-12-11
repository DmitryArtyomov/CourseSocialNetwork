class SearchController < ApplicationController
  def index
    redirect_to tag_path(params[:q][1..-1]) if query_is_tag?
    @profiles = find_profiles
  end

  private
  def query_is_tag?
    params[:q]&.first == '#'
  end

  def find_profiles
    Profile.search_by_full_name(params[:q]).includes(:user, :avatar)
  end
end
