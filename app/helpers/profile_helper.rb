module ProfileHelper
  def online_status
    return '' unless @profile.user.last_seen
    if @profile.user.last_seen > Time.now - 5.minutes
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
end
