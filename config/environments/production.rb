require 'rack/ssl'

DragonHoard::Application.configure do
  config.cache_classes = true

  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  config.action_dispatch.x_sendfile_header = "X-Sendfile"
  config.serve_static_assets = false

  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  
  config.middleware.insert_before ActionDispatch::Cookies, Rack::SSL
  config.middleware.insert_before ActionDispatch::Static,  Rack::SSL
end

Braintree::Configuration.environment  = :production
Braintree::Configuration.merchant_id  = "zpgq9twf6gjs6f2v"
Braintree::Configuration.public_key   = "pnfrrn3nmgksmp9y"
Braintree::Configuration.private_key  = "rbp5scx345dwfd8y"
