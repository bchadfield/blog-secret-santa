# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Secretsanta::Application.config.secret_key_base = APP_CONFIG['secret_key_base'] || 'b1cd9355a338a65ee6ca34b51017afb5fddb17cf0215490df6db86a8dc890f0d6542e4e7a7b1216351e04d1c30bd7e0e42c953096a050521dc99fccb65a6999f'
