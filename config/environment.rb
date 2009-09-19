RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'configatron'
  config.gem 'binarylogic-authlogic', :lib => 'authlogic', :source => 'http://gems.github.com'
  config.gem 'binarylogic-searchlogic', :lib => 'searchlogic', :source => 'http://gems.github.com'
  config.gem 'mislav-will_paginate', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem 'gdagley-validatable_form', :lib => 'validatable_form', :source => 'http://gems.github.com'
  config.gem 'less'
  
  config.gem 'relevance-log_buddy', :lib => 'log_buddy', :source => 'http://gems.github.com'

  config.gem 'populator', :lib => false
  config.gem 'faker', :lib => false
  
  config.time_zone = 'UTC'

  config.action_controller.session = {
   :session_key => '_basejumper_session',
   :secret      => '97ecd44e13fe9fc0bbcd6a6498ba77d60cd6174d242c62229f4efe84d89d5265ed1511f66ec87d499541f1566925d5f7d66a97979b267c54ca7784c1c1641f23'
  }
end