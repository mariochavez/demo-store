Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.default_strategies :admin_password
  manager.failure_app = lambda { |env| Backend::SessionController.action(:new).call(env) }
end

Warden::Manager.serialize_into_session(:admin) do |admin|
  admin.id
end

Warden::Manager.serialize_from_session(:admin) do |id|
  Admin.find(id)
end

Warden::Strategies.add(:admin_password) do
  def valid?
    params['admin'].present?
  end

  def authenticate!
    admin = Admin.find_by_email(params['admin']['email']).try(:authenticate, params['admin']['password'])

    if admin
      success! admin
    else
      fail! I18n.t('login_errors.message')
    end
  end
end
