MyStore::Application.configure do
  config.cache_classes                     = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.serve_static_assets               = false
  config.assets.compress                   = true
  config.assets.compile                    = true
  config.assets.digest                     = true
  config.i18n.fallbacks                    = true
  config.active_support.deprecation        = :notify

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => ENV['AWS_BUCKET'],
      :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
      :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
    }
  }
end
