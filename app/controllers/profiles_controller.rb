class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  load_and_authorize_resource

  def show
    @profile = @profile.decorate
  end

  def edit
  end

  def update
    if @profile.update_attributes(profile_params)
      flash[:notice] = "Profile succesfully updated"
      redirect_to profile_path @profile
    else
      render 'edit'
    end
  end

  private

  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :gender, :date_of_birth)
  end
end
