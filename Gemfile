source 'http://rubygems.org'
ruby '2.2.6'

gem 'rails', '~> 4.0'
gem 'responders', '~> 2.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development do
	gem 'sqlite3'
end

group :production do
	gem 'pg'
  gem 'heroku-deflater'
  gem 'newrelic_rpm'
  gem 'rails_12factor'
end

gem 'ruby_dep', '~> 1.3.1'
gem 'jbuilder'
gem 'json'

gem 'devise'
gem 'devise_token_auth'

gem 'cancancan'

gem 'rack-cors', :require => 'rack/cors'

gem 'omniauth'

gem 'omniauth-twitter'
gem 'twitter'
gem 'twitter-text'

gem 'omniauth-facebook'
gem "koala", "~> 1.7.0rc1"

gem 'rest-client'

gem 'mini_magick'
gem 'carrierwave'
gem 'fog-aws'

group :development, :test do
  gem 'rb-fsevent'
  gem "rspec"
  gem "rspec-rails"
  gem "capybara"
  gem "guard"
  gem "guard-rspec"
  gem 'terminal-notifier-guard'
  gem "factory_girl_rails"
  gem "database_cleaner"
	gem "byebug"
end
