# Your secret key verifies the integrity of signed cookies. Keep it outside source control.
# Changing it invalidates existing signed cookies. Use a distinct secret per environment.
secret_key_base = ENV.fetch('SECRET_KEY_BASE') do
  raise 'SECRET_KEY_BASE must be set to a securely generated signing secret.'
end

if secret_key_base.length < 30 || secret_key_base.strip.empty?
  raise 'SECRET_KEY_BASE must be a non-blank secret of at least 30 characters.'
end

Bikepark::Application.config.secret_key_base = secret_key_base
