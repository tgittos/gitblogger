# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_gitblogger_session',
  :secret      => '1b7841ecaa54aabf10e90864f8e7238c1fc68900142b80896d8da0181f60898ea46ae1362099f876ae48e0e10b1e9f864a978160f7619db7c728d110a4204208'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
