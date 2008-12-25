# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

module AuthLogicSpecHelper
  def login_as(user)
    user_session = mock_model(UserSession, {:record => user})
    UserSession.stub!(:find).and_return(user_session)
    user_session
  end
end

Spec::Runner.configure do |config|
  config.include(AuthLogicSpecHelper)
  # If you're not using ActiveRecord you should remove these
  # lines, delete config/database.yml and disable :active_record
  # in your config/boot.rb
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path = RAILS_ROOT + '/spec/fixtures/'
end

