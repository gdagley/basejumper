source 'https://rubygems.org'

gem 'unicorn'
gem 'rails'
gem 'jquery-rails'
gem 'rails_admin'
gem 'simple_form'
gem 'devise'
gem 'cancan'
gem 'role_model'
gem 'letters', :require => false

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'font-awesome-sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'therubyracer'
end

# for deploying to heroku
group :production do
  gem 'pg'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'sqlite3'
  gem 'capybara'
  gem 'rails_best_practices'
  gem 'simplecov'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'email_spec'
end

guard_notifications = true

group :development do
    gem 'better_errors'
    gem 'binding_of_caller'
    gem 'meta_request'
    gem 'rails-footnotes'
    gem 'annotate'
    gem 'quiet_assets'
    gem 'rb-fsevent'
    gem 'ruby_gntp' if guard_notifications
    gem 'yajl-ruby'
    gem 'rack-livereload'
    gem 'guard-livereload'
    gem 'guard-bundler'
    gem 'guard-cucumber'
    gem 'guard-rspec'
    gem 'guard-unicorn'
    gem 'heroku_san'
    gem 'term-ansicolor'
    gem 'pry-rails'
end
