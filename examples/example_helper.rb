ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

module AuthlogicSpecHelper
  def login_as(user)
    user_session = stub_everything(:record => user)
    UserSession.stubs(:find).returns(user_session)
    user_session
  end
end

def not_in_editor?
  ['TM_MODE', 'EMACS', 'VIM'].all? { |k| !ENV.has_key?(k) }
end

Micronaut.configure do |config|
  config.include AuthlogicSpecHelper
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :xit, :disabled => true
  config.mock_with :mocha
  config.color_enabled = not_in_editor?
  config.filter_run :focused => true  
  config.formatter = :documentation
  config.rails.enable_reasonable_defaults!
  config.rails.enable_active_record_transactional_support
end