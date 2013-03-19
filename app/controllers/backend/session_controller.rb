class Backend::SessionController < ApplicationController
  before_action :already_in_session!, except: :destroy

  def new
    @admin = Admin.new
  end

  def create
    warden.authenticate!(scope: :admin)

    respond_with @admin, location: backend_root_path
  end

  def destroy
    warden.logout(:admin)

    redirect_to backend_sign_in_path
  end
end
