module Micronaut
  module Rails
    module Extensions
      
      module ActiveRecord
        def errors_on(attribute)
          self.valid?
          [self.errors.on(attribute)].flatten.compact
        end
        alias :error_on :errors_on  
      end
      
    end
  end
end

if defined?(::ActiveRecord::Base)
  ::ActiveRecord::Base.send(:include, ::Micronaut::Rails::Extensions::ActiveRecord)
end