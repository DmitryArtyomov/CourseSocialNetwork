module ProfileHelper
  def online_status
    return '' unless @profile.user.last_seen
    if @profile.user.last_seen > Time.now - 10.minutes
      'Online'
    else
      "Last seen #{time_ago_in_words(@profile.user.last_seen)} ago"
    end
  end

  def current_profile
    if current_user
      @current_profile ||= current_user.profile
    else
      @current_profile = nil
    end
  end

  def resource_owner(profile)
    current_profile == profile ? 'My' : "#{profile.first_name.capitalize}'s"
  end

  def fa_icon_link(name, icon, options = nil, html_options = {})
    html_options[:class] ||= 'list-group-item'
    html_options[:title] ||= name
    link_to(options, html_options) do
      if html_options[:text_first]
        "<span>#{name} </span>".html_safe + fa_icon(icon)
      else
        fa_icon(icon) + "<span> #{name}</span>".html_safe
      end
    end
  end
end
