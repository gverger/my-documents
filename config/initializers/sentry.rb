# frozen_string_literal: true

Raven.configure do |config|
  config.dsn = Rails.application.credentials.dig(:sentry, :dsn)
end
