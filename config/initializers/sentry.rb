# frozen_string_literal: true

Sentry.init do |config|
  config.send_default_pii = true

  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
end
