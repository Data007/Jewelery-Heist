DragonHoardRails32::Application.configure do
  config.cache_classes = false
  config.whiny_nils = true
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options   = { host: 'localhost:300' }
  config.active_support.deprecation = :log
  config.action_dispatch.best_standards_support = :builtin
  config.assets.compress = false
  config.assets.debug = true
end

Braintree::Configuration.environment  = :sandbox
Braintree::Configuration.merchant_id  = "rx4jv5vwyf4z7crh"
Braintree::Configuration.public_key   = "9q5cqc64w32hmwj4"
Braintree::Configuration.private_key  = "xkdj42c9qhhzjv7z"
