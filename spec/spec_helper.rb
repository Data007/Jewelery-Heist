# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara/dsl'
require 'capybara/rails'
require 'database_cleaner'
require 'ruby-debug'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

require 'action_view'
include ActionView::Helpers::NumberHelper
include ActionView::Helpers::TextHelper
include ActionView::Helpers::UrlHelper

RSpec.configure do |config|
  config.mock_with :rspec
  config.include Mongoid::Matchers

  # Clean up the database
  config.before :suite do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end

  config.before :each do
    DatabaseCleaner.clean
  end
end

def login_admin(user, password)
  visit admin_root_path

  fill_in 'Login',    with: user.login
  fill_in 'Password', with: password
  click_button 'Login'
end

def soap
  save_and_open_page
end
