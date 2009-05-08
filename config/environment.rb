RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'configatron'
  config.gem 'authlogic'
  config.gem 'searchlogic'
  
  config.gem 'relevance-log_buddy', :lib => 'log_buddy', :source => 'http://gems.github.com'

  config.gem 'rspec', :lib => 'spec'
  config.gem 'rspec-rails', :lib => 'spec/rails'
  config.gem 'mocha'

  config.gem 'populator'
  config.gem 'faker'
  
  config.time_zone = 'UTC'

  config.action_controller.session = {
   :session_key => '_basejumper_session',
   :secret      => '97ecd44e13fe9fc0bbcd6a6498ba77d60cd6174d242c62229f4efe84d89d5265ed1511f66ec87d499541f1566925d5f7d66a97979b267c54ca7784c1c1641f23'
  }
end

require 'authlogic_system'
