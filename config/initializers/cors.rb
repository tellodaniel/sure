# frozen_string_literal: true

# CORS configuration for API access from mobile clients (Flutter) and other external apps.
#
# By default, only same-origin requests are allowed. To allow external clients
# (e.g., a Flutter mobile app), set CORS_ALLOWED_ORIGINS to a comma-separated
# list of origins:
#
#   CORS_ALLOWED_ORIGINS=https://app.example.com,capacitor://localhost
#
# Set CORS_ALLOWED_ORIGINS=* to allow any origin (not recommended for production).

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    allowed = ENV.fetch("CORS_ALLOWED_ORIGINS", "").split(",").map(&:strip).reject(&:blank?)

    if allowed.include?("*")
      origins "*"
    elsif allowed.any?
      origins(*allowed)
    else
      origins(/\Ahttps?:\/\/localhost(:\d+)?\z/)
    end

    # API endpoints for mobile client and third-party integrations
    resource "/api/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400

    # OAuth endpoints for authentication flows
    resource "/oauth/*",
      headers: :any,
      methods: %i[get post put patch delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400

    # Session endpoints for webview-based authentication
    resource "/sessions/*",
      headers: :any,
      methods: %i[get post delete options head],
      expose: %w[X-Request-Id X-Runtime],
      max_age: 86400
  end
end
