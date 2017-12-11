class PhotosController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource :profile
  load_and_authorize_resource :album, through: :profile
  load_and_authorize_resource through: :album

  def new
    @photo = Photo.new(photo_params)
  end

  def create
    if @photo.save
      redirect_to profile_album_photo_path(@profile, @photo.album_id, @photo)
    else
      render "new"
    end
  end

  def edit

  end

  def update
    if @photo.update_attributes(photo_params) && @photo.tags = TagService.new(params[:photo][:tags]).tags
      flash[:success] = "Photo was successfully updated"
      redirect_to profile_album_photo_path(@profile, @album, @photo)
    else
      flash[:alert] = "Error updating photo"
      render "edit"
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
      flash[:alert] = "Error deleting photo"
    end
    redirect_to profile_album_photos_path(@profile, @album)
  end

  def remove_avatar
    @profile.avatar = nil
    if @profile.save
      flash[:notice] = "Avatar was succesfully removed"
    else
      flash[:alert] = "Error removing avatar"
    end
    redirect_to profile_path(@profile)
  end

  def set_avatar
    @profile.avatar = @photo
    if @profile.save
      flash[:notice] = "Avatar was succesfully set"
    else
      flash[:alert] = "Error setting avatar"
    end
    redirect_to profile_path(@profile)
  end

  private

  def photo_params
    params.fetch(:photo, {}).permit(:image, :profile_id, :album_id, :description)
  end
end
