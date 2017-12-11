class AlbumsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  load_and_authorize_resource :profile
  load_and_authorize_resource through: :profile

  def new
    authorize! :create_nested_resource, @profile
  end

  def create
    if @album.save && @album.tags = TagService.new(params[:album][:tags]).tags
      flash[:success] = "Album was successfully created"
      redirect_to profile_album_path(@profile, @album)
    else
      flash[:alert] = "Error creating album"
      render "new"
    end
  end

  def index
    @albums = @albums.includes(:photos)
    @photos = @profile.photos.order(created_at: :desc)
  end

  def show
    @photos = @album.photos.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @album.update_attributes(album_params) && @album.tags = TagService.new(params[:album][:tags]).tags
      flash[:success] = "Album was successfully updated"
      redirect_to profile_album_path(@profile, @album)
    else
      flash[:alert] = "Error updating album"
      render "edit"
    end
  end

  def destroy
    if @album.destroy
      flash[:success] = "Album was successfully deleted"
      redirect_to profile_albums_path(@profile)
    else
      flash[:alert] = "Error deleting album"
      render "edit"
    end
  end

  private

  def album_params
    params.require(:album).permit(:name, :description)
  end
end
