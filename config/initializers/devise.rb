# frozen_string_literal: true

# Make sure Devise loads the ActiveRecord ORM
require 'devise/orm/active_record'

# Use this hook to configure devise mailer, warden hooks and so forth.
Devise.setup do |config|
  config.mailer_sender = 'please-change-me@example.com'
  
  # The ORM to use
  require 'devise/orm/active_record'
  
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 12
  config.reconfirmable = true
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.sign_out_via = :delete
  
  # Configure JWT
  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.secret_key_base
    jwt.dispatch_requests = [
      ['POST', %r{^/users/sign_in$}]
    ]
    jwt.revocation_requests = [
      ['DELETE', %r{^/users/sign_out$}]
    ]
    jwt.expiration_time = 24.hours.to_i
  end
end