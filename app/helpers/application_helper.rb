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

  def current_profile
    if current_user
      @current_profile ||= current_user.profile
    else
      @current_profile = nil
    end
  end
end
