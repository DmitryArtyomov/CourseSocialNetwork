class UsersConfirmService
  def initialize(user)
    @user = user
  end

  def execute
    create_main_album
  end

  private

  attr_reader :user

  def create_main_album
    profile = user.profile
    profile.albums.create(name: 'Main album', is_main: true) unless profile.albums.any?
  end
end
