class ProfileDecorator < Draper::Decorator
  delegate_all

  def online_status
    return '' unless object.user.last_seen
    if online?
      'Online'
    else
      "Last seen #{h.time_ago_in_words(object.user.last_seen)} ago"
    end
  end

  def full_name
    "#{object.first_name} #{object.last_name}"
  end

  def current?
    object == h.current_profile
  end

  def online?
    object.user.last_seen > Time.now - 10.minutes
  end
end
