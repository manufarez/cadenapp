Turnstile.configure do |config|
  if Rails.env.development?
    config.enabled = false
  end
  config.site_key = Rails.application.credentials.turnstile.site_key
  config.secret_key = Rails.application.credentials.turnstile.secret_key
end
