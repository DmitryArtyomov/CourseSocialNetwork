class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.id
      can [:update], Profile, user_id: user.id
      can [:create, :update, :delete, :set_avatar, :remove_avatar], Photo, profile: { user_id: user.id }
    end
    can :read, [Profile, Photo]
  end
end
