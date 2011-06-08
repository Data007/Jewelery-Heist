require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env) if defined?(Bundler)

module DragonHoard
  class Application < Rails::Application
    config.autoload_paths << File.join(config.root, "lib")
    
    # Generators
    config.generators do |g|
      # g.orm                 :mongoid
      g.template_engine     :haml
      g.test_framework      :rspec
      g.fixture_replacement :factory_girl
    end
    
    config.time_zone = 'Arizona'
    
    config.action_view.javascript_expansions[:defaults] = %w(jquery rails)
    config.encoding = "utf-8"

    config.filter_parameters += [:password, :password_confirmation, :fb_sig_friends]
  end
end
