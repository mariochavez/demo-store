module ApplicationHelper
  def display_current_admin
    return unless admin_logged?

    message = link_to backend_profile_path do |t|
      name = content_tag :span do
        t('.welcome', email: current_admin.profile.present? ? current_admin.profile.name : current_admin.email)
      end
      name << image_tag(current_admin.profile.avatar(:thumb), width: '32px').html_safe if current_admin.profile.present?
    end
    message << ' | '
    message << link_to(t('.logout'), backend_session_destroy_path, method: :delete, class: 'logout')
    message.html_safe
  end

  def display_alert
    content_tag :div, class: 'alert' do
      flash[:alert] || warden.message
    end if flash[:alert] || warden.message.present?
  end

  def display_notice
    content_tag :div, class: 'notice' do
      flash[:notice]
    end if flash[:notice]
  end

  def field_error(model, field)
    Rails.logger.debug model.errors.inspect
    if model.errors[field].any?
      content_tag :span, class: 'error' do
        model.errors[field].first
      end
    end
  end
end
