class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_admin, :admin_logged?, :warden

  self.responder = ActionsResponder
  respond_to :html

protected
  def debug_to_log(message)
    logger.debug "\033[0;33m#{message}\033[0;37m""]']"
  end

  def already_in_session!
    redirect_to backend_root_path if admin_logged?
  end

  def authenticate!
    redirect_to backend_sign_in_path unless admin_logged?
  end

  def admin_logged?
    warden.authenticate?(scope: :admin)
  end

  def current_admin
    warden.user(scope: :admin)
  end

  def warden
    request.env['warden']
  end
end
