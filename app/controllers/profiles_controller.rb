class ProfilesController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]
  load_and_authorize_resource except: [:show]

  def show
    @profile = Profile.includes(:user, :avatar).find(params[:id])
    authorize! :show, @profile
    @profile = @profile.decorate
    if user_signed_in? && !@profile.current?
      @accepted_request = current_profile.accepted_friend_request_with(@profile)
      @out_unaccepted_request = current_profile.out_unaccepted_request_with(@profile)
      @in_unaccepted_request = current_profile.in_unaccepted_request_with(@profile)
    end
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
