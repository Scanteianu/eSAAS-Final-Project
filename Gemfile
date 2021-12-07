source 'https://rubygems.org'

ruby '>= 2.6.6', '< 2.7.0'
gem 'rails', '~> 5.2.0'
gem 'pg', '~> 0.18'
gem 'mini_magick'
gem 'bootsnap'
gem 'aws-sdk-s3'

# for Heroku deployment
group :development, :test do
  gem 'sqlite3', '1.3.11'
  gem 'byebug'
  gem 'database_cleaner'
  gem 'capybara', '~> 2.8'
  gem 'launchy'
  gem 'rspec-rails', '3.7.2'
  gem 'ZenTest', '4.11.2'
  gem 'listen'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'cucumber-rails-training-wheels'
  gem 'simplecov', :require => false
  gem 'selenium-webdriver'
  gem 'webdrivers'
  gem 'rspec-retry'
end
group :production do
  gem 'bundler', '>= 1.30'
end

# Gems used only for assets and not required
# in production environments by default.

gem 'sass-rails', '~> 5.0.3'
gem 'uglifier', '>= 3.2.0'
gem 'jquery-rails'
