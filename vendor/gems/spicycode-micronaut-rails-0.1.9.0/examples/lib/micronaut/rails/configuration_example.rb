require File.expand_path(File.dirname(__FILE__) + "/../../../example_helper")

describe Micronaut::Rails::Configuration do

  example "loading micronaut rails include it in the micronaut configuration class" do
    Micronaut::Configuration.included_modules.should include(Micronaut::Rails::Configuration)
  end
  
  it "should add a #rails method" do
    Micronaut.configuration.should respond_to(:rails)
  end
  
  it "should add an #enable_active_record_transactional_support method" do
    Micronaut.configuration.should respond_to(:enable_active_record_transactional_support)
  end
  
  describe "helpers for standard Rails testing support" do
    
    method_to_modules = { :enable_helper_support => Micronaut::Rails::Helpers,
                          :enable_active_record_transactional_support => Micronaut::Rails::TransactionalDatabaseSupport,
                          :enable_controller_support => Micronaut::Rails::Controllers
                        }
    method_to_modules.each do |method, mod| 
      example "##{method} with no filter options" do
        Micronaut.configuration.send(method)
        Micronaut.configuration.include_or_extend_modules.should include([:extend, mod, {}])
      end
      
      example "##{method} with filter options" do
        filter_options = {:options => { "foo" => "bar" } }
        Micronaut.configuration.send(method, filter_options)
        Micronaut.configuration.include_or_extend_modules.should include([:extend, mod, filter_options])
      end
    end
    
    example "#enable_rails_specific_mocking_extensions for mocha with no filter options" do
      Micronaut.configuration.mock_with :mocha
      Micronaut.configuration.enable_rails_specific_mocking_extensions
      Micronaut.configuration.include_or_extend_modules.should include([:include, Micronaut::Rails::Mocking::WithMocha, {}])
    end

  end

end