module Micronaut
  module Rails
    module Mocking
      
      module WithRR
        # Creates a mock object instance for a +model_class+ with common
        # methods stubbed out. Additional methods may be easily stubbed (via
        # add_stubs) if +stubs+ is passed.
        def mock_or_stub_model(model_class, mock_or_stub, options = {})
          model = model_class.new
          model.extend ::Micronaut::Rails::Mocking::ModelStubber
          model_id = next_id

          stub(errors_stub = Object.new).count.returns(0)
          full_params = { :id => model_id, :new_record? => false, :errors => errors_stub }.update(options)
          
          full_params.each do |method, value|
            eval "#{mock_or_stub}(model).#{method}.returns(value)", binding, __FILE__, __LINE__
          end
          
          yield model if block_given?
          model
        end
        
        def mock_model(model_class, options = {})
          mock_or_stub_model(model_class, 'mock', options)
        end

        def stub_model(model_class, options = {})
          mock_or_stub_model(model_class, 'stub', options)
        end
        
        private
        
        @@model_id = 1000
        def next_id
          @@model_id += 1
        end
        
      end

    end
  end
end