class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.id
      can [:update], Profile, user_id: user.id
      can [:create, :update, :delete, :set_avatar, :remove_avatar], Photo, profile: { user_id: user.id }

      can :create,  FriendRequest, sender:    { user_id: user.id }
      can :destroy, FriendRequest, sender:    { user_id: user.id }, status: 1
      can :destroy, FriendRequest, recipient: { user_id: user.id }, status: 1
      can :accept,  FriendRequest do |fr|
        fr.recipient.user_id == user.id && !fr.accepted?
      end
      can :decline, FriendRequest, recipient: { user_id: user.id }, status: 0
      can :cancel,  FriendRequest do |fr|
        fr.sender.user_id == user.id && !fr.accepted?
      end
      can :index,   FriendRequest, recipient: { user_id: user.id }
      can :index,   FriendRequest, sender:    { user_id: user.id }

      can [:view_requests, :view_conversations], Profile, user_id: user.id

      can [:create, :read, :update], Conversation, profiles: { user_id: user.id }
      can :create, Message, sender: { user_id: user.id }, conversation: { profiles: { user_id: user.id } }
    end
    can :read, [Profile, Photo]
    can :index, FriendRequest, status: 1
  end
end
