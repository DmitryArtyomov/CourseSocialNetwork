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
    if (badge_count = html_options[:badge_count]) && badge_count > 0
      badge = <<-BADGE
      <span class='badge'>#{badge_count}</span>
      <div class='visible-sm'>
        <div class='badge'>#{badge_count}</div>
      </div>
      BADGE
      url = html_options[:badge_url]
    end
    link_to(url, html_options) do
      if html_options[:text_first]
        "<span>#{name} </span>".html_safe + fa_icon(icon) + "#{badge}".html_safe
      else
        fa_icon(icon) + "<span> #{name}</span>#{badge}".html_safe
      end
    end
  end
end
