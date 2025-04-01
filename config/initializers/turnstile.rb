Turnstile.configure do |config|
  if Rails.env.production?
    config.enabled = true
    config.site_key = Rails.application.credentials.turnstile.site_key
    config.secret_key = Rails.application.credentials.turnstile.secret_key
  end
end
