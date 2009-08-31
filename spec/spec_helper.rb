# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'
require 'rspec_rails_mocha'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module AuthlogicSpecHelper
  def login_as(user)
    user_session = stub_everything(:record => user)
    UserSession.stubs(:find).returns(user_session)
    user_session
  end
end

Spec::Runner.configure do |config|
  config.include AuthlogicSpecHelper
  
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'

  config.mock_with :mocha
end
