class ProfileController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(settings_params)
      flash[:notice] = "Profile succesfully updated"
      redirect_to show_profile_path @user
    else
      render 'edit'
    end
  end

  private

    def settings_params
      params.require(:user).permit(:first_name, :last_name, :gender, :date_of_birth)
    end
end
