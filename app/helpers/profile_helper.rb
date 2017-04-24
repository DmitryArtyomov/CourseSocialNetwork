module ProfileHelper
  def resource_owner(profile)
    current_profile == profile ? 'My' : "#{profile.first_name.capitalize}"
  end
end
