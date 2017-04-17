class PhotosController < ApplicationController
  include ProfileHelper

  before_action :authenticate_user!, except: [:index, :show]

  def new
    @photo = Photo.new
  end

  def create
    @photo = Photo.new(photo_params)
    @photo.profile = current_profile
    if @photo.save
      redirect_to @photo
    else
      render "new"
    end
  end

  def show
    @photo = Photo.find(params[:photo_id])
  end

  def index
    @photos = Photo.where(profile: params[:profile_id])
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.profile == current_profile
      set_avatar if params[:set_avatar]
    end
  end

  private

  def set_avatar
    @photo = Photo.find(params[:id])    
    current_profile.avatar = @photo
    if current_profile.save
      flash[:notice] = "Avatar succesfully set"
    else
      flash[:error] = "Error setting avatar"
    end
    redirect_to show_profile_path @photo.profile
  end

  def photo_params
    params.require(:photo).permit(:image)
  end
end
