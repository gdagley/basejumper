require "rbconfig"
HOST_OS = RbConfig::CONFIG["host_os"]

source "https://rubygems.org"

gem "unicorn"
gem "rails", "3.2.3"
gem "jquery-rails"
gem "rails_admin"
gem "rspec-rails", :group => [:development, :test]
gem "sqlite3", :group => [:development, :test]

gem "simple_form"

gem "devise"
gem "cancan"
gem "role_model"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem "sass-rails",   "~> 3.2.3"
  gem "coffee-rails", "~> 3.2.1"
  gem "uglifier", ">= 1.0.3"
  gem "twitter-bootstrap-rails"
  gem "therubyracer"
end

gem "capybara", :group => [:development, :test]
group :test do
  gem "cucumber-rails", :require => false
  gem "capybara"
  gem "database_cleaner"
end

guard_notifications = true

group :development do
  case HOST_OS
    when /darwin/i
      gem "rb-fsevent"
      gem "ruby_gntp" if guard_notifications
    when /linux/i
      gem "libnotify"
      gem "rb-inotify"
    when /mswin|windows/i
      gem "rb-fchange"
      gem "win32console"
      gem "rb-notifu" if guard_notifications
  end

  gem "yajl-ruby"
  gem "rack-livereload"
  gem "guard-livereload"
  gem "guard-bundler"
  gem "guard-cucumber"
  gem "guard-rspec"
  gem "guard-unicorn"
  gem "heroku_san"
end