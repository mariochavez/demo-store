ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)

require "minitest/autorun"
require "minitest/rails"
require "minitest/rails/capybara"
require "minitest/colorize"

# Add `gem "minitest-rails-capybara"` to the test group of your Gemfile
# and uncomment the following if you want Capybara feature tests
# require "minitest/rails/capybara"

# Uncomment if you want awesome colorful output
# require "minitest/pride"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def stub_current_admin(id = 100)
    ApplicationController.class_exec(id) do |id|
      body = -> { @current_admin ||= Admin.find id }
      define_method :current_admin, body
    end
  end

  def destroy_session!
    ApplicationController.class_eval do
      define_method :admin_logged?, -> { false }
    end
  end
end

class MiniTest::Unit::TestCase
  include Rails.application.routes.url_helpers
  include Capybara::RSpecMatchers
  include Capybara::DSL

  def setup
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
    Admin.create! email: email, password: 'password', password_confirmation: 'password'

    visit '/backend/sign_in'

    within('#new_admin') do
      fill_in 'admin_email', with: email
      fill_in 'admin_password', with: 'password'
    end
    click_button 'login'
  end
end
