source 'https://rubygems.org'

gem 'rails', '3.2.8'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'compass'
end

gem 'coffee-filter'
gem 'haml_coffee_assets'
gem 'execjs'

# http://collectiveidea.com/blog/archives/2010/11/29/ssl-with-rails/
gem 'rack-ssl'

gem 'jquery-rails'

gem 'haml'
gem 'haml-rails'
gem 'aws-sdk'
gem 'mongoid', '~>3.0'
gem 'mongoid-paperclip', require: 'mongoid_paperclip'
gem 'mongoid-sequence', git: 'https://github.com/dragonhoard/mongoid-sequence.git'
gem 'dynamic_form'

gem 'therubyracer'

gem 'omniauth' # It's a sane default these days
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

gem 'braintree'
gem 'credit_card_validator'

gem 'airbrake'

gem 'formatize'
gem 'escape_utils'
gem 'stringex'
gem 'will_paginate', '~> 3.0.2'

group :production do
  gem 'thin'
  gem 'newrelic_rpm', '3.4.1'
  ruby '1.9.3'
end

group :development do
  gem 'heroku'
  gem 'taps'
  gem 'thin'
end

group :test, :development do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'mongoid-rspec'
  gem 'timecop'
  gem 'vcr'
  gem 'fakeweb'
  gem 'email_spec' 
  gem 'rack_session_access'
  gem 'pry'
  gem 'pry-nav'

  # Pretty printed test output
  gem 'turn', require: false
end

