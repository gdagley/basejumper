module Micronaut
  module Rails
    
    module Configuration
      
      def rails
        self
      end
      
      # :behaviour => { :describes => lambda { |dt| dt < ActiveRecord::Base }
      def enable_active_record_transactional_support(filter_options={})
        ::Micronaut.configuration.extend(::Micronaut::Rails::TransactionalDatabaseSupport, filter_options)
      end
      
      # :behaviour => { :describes => lambda { |dt| dt.to_s.ends_with?('Helper') }
      def enable_helper_support(filter_options={})
        ::Micronaut.configuration.extend(::Micronaut::Rails::Helpers, filter_options)
      end
      
      # :behaviour => { :describes => lambda { |dt| dt < ActionController::Base } 
      def enable_controller_support(filter_options={})
        ::Micronaut.configuration.extend(::Micronaut::Rails::Controllers, filter_options)
      end
      
      def enable_rails_specific_mocking_extensions(filter_options={})
        case ::Micronaut.configuration.mock_framework.to_s
        when /mocha/i
          require 'micronaut/rails/mocking/with_mocha'
          ::Micronaut.configuration.include(::Micronaut::Rails::Mocking::WithMocha, filter_options)
         when /rr/i
          require 'micronaut/rails/mocking/with_rr'
          ::Micronaut.configuration.include(::Micronaut::Rails::Mocking::WithRR, filter_options)
        end
      end
      
      def enable_reasonable_defaults!
        enable_active_record_transactional_support :behaviour => { :describes => lambda { |dt| dt < ::ActiveRecord::Base } }
        enable_helper_support :behaviour => { :describes => lambda { |dt| dt.to_s.ends_with?('Helper') } }
        enable_controller_support :behaviour => { :describes => lambda { |dt| dt < ::ActionController::Base } }
        enable_rails_specific_mocking_extensions
      end
      
    end
    
  end
end

::Micronaut::Configuration.send(:include, ::Micronaut::Rails::Configuration)