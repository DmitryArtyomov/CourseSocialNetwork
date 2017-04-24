class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile

  def new
    @photo = Photo.new(photo_params)
  end

  def create
    if @photo.save
      redirect_to profile_photo_path(@photo.profile, @photo)
    else
      render "new"
    end
  end

  def show
  end

  def index
    @photos = @photos.order(created_at: :desc)
    @profile = @profile.decorate
  end

  def destroy
    if @photo.destroy
      @photo.image.remove!
      flash[:notice] = "Photo was succesfully deleted"
    else
      flash[:error] = "Error deleting photo"
    end
    redirect_to profile_photos_path(@profile)
  end

  def remove_avatar
    @profile.avatar = nil
    if @profile.save
      flash[:notice] = "Avatar was succesfully removed"
    else
      flash[:error] = "Error removing avatar"
    end
    redirect_to profile_path(@profile)
  end

  def set_avatar
    @profile.avatar = @photo
    if @profile.save
      flash[:notice] = "Avatar was succesfully set"
    else
      flash[:error] = "Error setting avatar"
    end
    redirect_to profile_path(@profile)
  end

  private

  def photo_params
    params.fetch(:photo, {}).permit(:image, :profile_id)
  end
end
