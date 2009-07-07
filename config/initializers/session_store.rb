# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_cuesite_session',
  :secret      => 'f37ac8adafa95e6ffba59da9d1a31bcaa1eb4bda8f5f97dfd332d755f43b35dba3a7bf4939a0181f7af0f77cd1f7ff4fc2dadeacd97522399a47d742fbb82355'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
