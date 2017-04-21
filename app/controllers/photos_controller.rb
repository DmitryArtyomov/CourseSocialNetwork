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
      redirect_to profile_photo_path(profile_id: @photo.profile, id: @photo)
    else
      render "new"
    end
  end

  def show
    @photo = Photo.where(profile: params[:profile_id]).find(params[:id])
  end

  def index
    @photos = Photo.where(profile: params[:profile_id]).order(id: :desc)
    @profile = Profile.find_by(id: params[:profile_id]).decorate
  end

  def update
    @photo = Photo.find(params[:id])
    if @photo.profile == current_profile
      set_avatar if params[:set_avatar]
      remove_avatar if params[:remove_avatar]
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    profile = @photo.profile
    if profile == current_profile
      if @photo.destroy
        @photo.image.remove!
        flash[:notice] = "Photo was succesfully deleted"
      else
        flash[:error] = "Error deleting photo"
      end
    end
    redirect_to profile_photos_path(profile_id: profile)
  end

  private

  def remove_avatar
    current_profile.avatar = nil
    if current_profile.save
      flash[:notice] = "Avatar was succesfully removed"
    else
      flash[:error] = "Error removing avatar"
    end
    redirect_to profile_path @photo.profile
  end

  def set_avatar
    @photo = Photo.find(params[:id])
    current_profile.avatar = @photo
    if current_profile.save
      flash[:notice] = "Avatar was succesfully set"
    else
      flash[:error] = "Error setting avatar"
    end
    redirect_to profile_path @photo.profile
  end

  def photo_params
    params.fetch(:photo, {}).permit(:image)
  end
end
