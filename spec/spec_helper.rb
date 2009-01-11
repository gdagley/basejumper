# This file was originally used for rspec, but has been converted to support micronaut (and ./script/autotest still works)
# Notable changes:
#  * converted specs to use mocha
#  * removed spec/spec.opts
#  * removed spec/rcov.opts

ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

module AuthlogicSpecHelper
  def login_as(user)
    user_session = mock_model(UserSession, {:record => user})
    UserSession.stubs(:find).returns(user_session)
    user_session
  end
end

def not_in_editor?
  ['TM_MODE', 'EMACS', 'VIM'].all? { |k| !ENV.has_key?(k) }
end

def rubygem_gem_paths
  Gem.path.map do |path|
    /#{Regexp.escape(path)}/i
  end
end

Micronaut.configure do |config|
  config.include(AuthlogicSpecHelper)
  
  rubygem_gem_paths.each { |gem_path_regex| config.backtrace_clean_patterns << gem_path_regex }
  
  config.alias_example_to :they
  config.alias_example_to :fit, :focused => true
  config.alias_example_to :xit, :disabled => true
  
  config.mock_with :mocha
  config.color_enabled = not_in_editor?
  # config.profile_examples = true
  # config.filter_run :focused => true
  config.rails.enable_helper_support :behaviour => { :describes => lambda { |dt| dt.to_s.ends_with?('Helper') } }
  config.rails.enable_controller_support :behaviour => { :describes =>  lambda { |dt| dt < ActionController::Base } }
  config.rails.enable_rails_specific_mocking_extensions
 end