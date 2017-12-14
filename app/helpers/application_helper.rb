module ApplicationHelper
  def error_messages(resource)
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    sentence = I18n.t('errors.messages.not_saved',
      count: resource.errors.count,
      resource: resource.class.model_name.human.downcase)

    html = <<-HTML
    <div class="alert alert-danger alert-block devise-bs">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      <h5>#{sentence}</h5>
      <ul>#{messages}</ul>
    </div>
    HTML

    html.html_safe
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def fa_icon_link(name, icon, url = nil, html_options = {})
    html_options[:class] ||= 'list-group-item'
    html_options[:title] ||= name
    badge_count = html_options[:badge_count].to_i > 0 ? html_options[:badge_count] : ''
    badge = <<-BADGE
    <span class='badge'>#{badge_count}</span>
    <div class='visible-sm'>
      <div class='badge'>#{badge_count}</div>
    </div>
    BADGE
    url = html_options[:badge_url] if html_options[:badge_url] && badge_count.to_i > 0
    link_to(url, html_options.except(:badge_count, :badge_url, :text_first)) do
      if html_options[:text_first]
        "<span>#{name} </span>".html_safe + fa_icon(icon) + "#{badge}".html_safe
      else
        fa_icon(icon) + "<span> #{name}</span>#{badge}".html_safe
      end
    end
  end

  def short_time(datetime)
    datetime = datetime.localtime
    if is_today?(datetime)
      datetime.strftime "%H:%M"
    elsif datetime.to_date == Date.yesterday
      "yesterday"
    else
      datetime.strftime "%-d %B"
    end
  end

  def full_time(datetime)
    datetime = datetime.localtime
    if is_today?(datetime)
      datetime.strftime "%H:%M"
    else
      datetime.strftime "%-d %B %H:%M"
    end
  end

  def time_ago(datetime)
    datetime = datetime.localtime
    if is_today?(datetime)
      time_ago_in_words(datetime) + ' ago'
    else
      datetime.localtime.strftime "%-d %B %H:%M"
    end
  end

  def current_profile?(profile)
    profile && current_profile == profile
  end

  private def is_today?(datetime)
    datetime.to_date >= Date.today
  end
end
