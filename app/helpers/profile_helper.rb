module ProfileHelper
  def resource_owner(profile, mine = 'My')
    current_profile == profile ? mine : "#{profile.first_name.capitalize}"
  end
end
