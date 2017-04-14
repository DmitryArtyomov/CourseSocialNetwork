class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @profile = Profile.find(params[:id])
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    if @profile.update_attributes(settings_params)
      flash[:notice] = "Profile succesfully updated"
      redirect_to show_profile_path @profile
    else
      render 'edit'
    end
  end

  private

    def settings_params
      params.require(:profile).permit(:first_name, :last_name, :gender, :date_of_birth)
    end
end
