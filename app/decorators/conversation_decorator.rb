class ConversationDecorator < Draper::Decorator
  delegate_all

  def name(profile)
    profs = profiles_without(profile)
    profs.map{ |p| p.decorate.full_name }.join(', ')
  end

  def avatar(profile)
    profs = profiles_without(profile)
    profs.first.avatar ? profs.first.avatar.image.url : h.image_url('no-avatar.png')
  end

  private

  def profiles_without(profile)
    @profs_without ||= {}
    @profs_without[profile.id] ||= object.profiles.where.not(id: profile.id).includes(:avatar)
  end
end
