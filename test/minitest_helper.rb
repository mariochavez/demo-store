ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/colorize"

class ActiveSupport::TestCase
  include Warden::Test::Helpers
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def setup
    Warden.test_reset!
    setup_warden
  end

  def request
    @request ||= ActionController::TestRequest.new
  end

  def setup_warden
    @warden ||= begin
      manager = Warden::Manager.new(nil, &Rails.application.config.middleware.detect{|m| m.name == 'Warden::Manager'}.block)
      request.env['warden'] = Warden::Proxy.new(@request.env, manager)
    end
  end
  alias_method :warden, :setup_warden

  def stub_current_admin(id = 100)
    admin = Admin.find id
    warden.set_user(admin, scope: :admin)
  end
end

class MiniTest::Unit::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::RSpecMatchers
  include Capybara::DSL
  include Warden::Test::Helpers

  def setup
    Warden.test_reset!
    Capybara.reset_sessions!
  end

  def teardown
    Capybara.current_driver = nil
  end

  def use_javascript
    Capybara.current_driver = Capybara.javascript_driver
  end

  def login_admin
    counter = Admin.count + 1
    email = "admin#{counter}@store.com"
    admin = Admin.create! email: email, password: 'password', password_confirmation: 'password'

    visit '/backend/sign_in'

    within('#new_admin') do
      fill_in 'admin_email', with: email
      fill_in 'admin_password', with: 'password'
    end

    click_button 'login'
    admin
  end
end
