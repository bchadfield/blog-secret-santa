source 'https://rubygems.org'

gem 'rails', '4.2.0'

gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 5.0.0'
  #gem 'coffee-rails', '~> 4.1.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.3.0'
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-turbolinks'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 1.2'

gem 'omniauth-twitter', '~> 1.0.1'
gem 'omniauth-facebook', '~> 2.0.0'
gem 'devise', '~> 3.4.0'

gem 'whenever', :require => false
gem "unshorten", "~> 0.2.1"
gem 'nokogiri'
gem "premailer-rails", "~> 1.6.1"
gem 'docx', git: 'git@github.com:bchadfield/docx.git'
gem 'kramdown', '~> 1.3.3'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :production do
  gem 'unicorn'
  # gem 'puma'
end

group :development do
  gem 'capistrano', '~> 3.2', require: false
  gem 'capistrano-rails', '~> 1.1', require: false
  gem 'capistrano-bundler', '~> 1.1', require: false
  gem 'capistrano-rbenv', '~> 2.0', require: false
  gem 'web-console', '~> 2.0'
  gem 'letter_opener'
end
