class RegistrationsController < Devise::RegistrationsController

  def new
    build_resource({})
    resource.build_profile
    respond_with self.resource
  end

  private

  def sign_up_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      profile_attributes: [:first_name, :last_name, :date_of_birth, :gender]
    )
  end

  def account_update_params
    params.require(:user).permit(:email, :password, :password_confirmation, :current_password)
  end
end
