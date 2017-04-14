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
    @photo = Photo.find(params[:id])
  end

  private

  def photo_params
    params.require(:photo).permit(:image)
  end
end
