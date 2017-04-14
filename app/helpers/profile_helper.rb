module ProfileHelper
  def online_status
    return '' unless @profile.user.last_seen
    if @profile.user.last_seen > Time.now - 5.minutes
      'Online'
    else
      "Last seen #{time_ago_in_words(@profile.user.last_seen)} ago"
    end
  end
end
