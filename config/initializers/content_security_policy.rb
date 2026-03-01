# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data
    policy.img_src     :self, :data, :https
    policy.object_src  :none
    policy.script_src  :self
    policy.style_src   :self, :unsafe_inline
    policy.connect_src :self

    if ENV["SENTRY_DSN"].present?
      sentry_host = URI.parse(ENV["SENTRY_DSN"]).host rescue nil
      if sentry_host
        policy.connect_src :self, "https://#{sentry_host}"
      end
    end
  end

  # Generate session nonces for permitted importmap and inline scripts.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]

  # Report violations without enforcing the policy.
  # Uncomment the line below to start in report-only mode while you verify
  # nothing is broken, then remove it to enforce.
  # config.content_security_policy_report_only = true
end
