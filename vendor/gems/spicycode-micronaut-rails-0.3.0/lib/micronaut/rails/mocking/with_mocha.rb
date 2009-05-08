module Micronaut
  module Rails
    module Mocking
      module WithMocha

        def stub_model(model_class, params = {})
          params = params.dup
          model = model_class.new
          model.id = params.delete(:id) || next_id
          model.extend ::Micronaut::Rails::Mocking::ModelStubber
          
          params.keys.each do |prop|
            model[prop] = params.delete(prop) if model.has_attribute?(prop)
          end
          add_stubs(model, params)

          yield model if block_given?
          model
        end

        # Stubs methods on +object+ (if +object+ is a symbol or string a new mock
        # with that name will be created). +stubs+ is a Hash of +method=>value+
        def add_stubs(object, params) # :nodoc:
          m = [String, Symbol].include?(object.class) ? mock(object.to_s) : object
          params.each { |prop, value| m.stubs(prop).returns(value) }
          m
        end

        def mock_model(model_class, params = {})
          id = params[:id] || next_id
          model = stub("#{model_class.name}_#{id}", {
            :id => id,
            :to_param => id.to_s,
            :new_record? => false,
            :errors => stub("errors", :count => 0)
            }.update(params))

            model.instance_eval <<-CODE
            def as_new_record
              self.stubs(:id).returns(nil)
              self.stubs(:to_param).returns(nil)
              self.stubs(:new_record?).returns(true)
              self
            end
            def is_a?(other)
              #{model_class}.ancestors.include?(other)
            end
            def kind_of?(other)
              #{model_class}.ancestors.include?(other)
            end
            def instance_of?(other)
              other == #{model_class}
            end
            def class
              #{model_class}
            end
            CODE

            yield model if block_given?
            return model
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