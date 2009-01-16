module Micronaut
  module Rails
    module Controllers

      module InstanceMethods
        attr_reader :request, :response, :controller

        def assert_routing(path, options, defaults={}, extras={}, message=nil)
          method = options[:method] || :get
          route_for(params_from(method, path)).should == path
        end
        
        def route_for(options)
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
          ActionController::Routing::Routes.generate(options)
        end

        def params_from(method, path)
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
          ActionController::Routing::Routes.recognize_path(path, :method => method)
        end
          
      end

      module RenderOverrides
        
        def render_views!
          @render_views = true
        end

        def render_views?
          @render_views
        end
        
        def render(options=nil, deprecated_status_or_extra_options=nil, &block)
          if ::Rails::VERSION::STRING >= '2.0.0' && deprecated_status_or_extra_options.nil?
            deprecated_status_or_extra_options = {}
          end
          Micronaut.configuration.trace { "In RenderOverrides#render with options => #{options.inspect}, deprecated_status_or_extra_options => #{deprecated_status_or_extra_options.inspect}, render_views? => #{render_views?.inspect}"}
          response.headers['Status'] = interpret_status((options.is_a?(Hash) && options[:status]) || ::ActionController::Base::DEFAULT_RENDER_STATUS_CODE)
                    
          unless block_given?
            unless render_views?
              if @template.respond_to?(:finder)
                (class << @template.finder; self; end).class_eval do
                  define_method :file_exists? do; true; end
                end
              else
                (class << @template; self; end).class_eval do
                  define_method :file_exists? do; true; end
                end
              end
              (class << @template; self; end).class_eval do

                define_method :render_file do |*args|
                  @first_render ||= args[0] unless args[0] =~ /^layouts/
                  @_first_render ||= args[0] unless args[0] =~ /^layouts/
                end

                define_method :_pick_template do |*args|
                  @_first_render ||= args[0] unless args[0] =~ /^layouts/
                  PickedTemplate.new
                end

              end
              
            end
          end     
          
          super(options, deprecated_status_or_extra_options, &block)
        end

      end

      # Returned by _pick_template when running controller examples in isolation mode.
      class PickedTemplate 
        # Do nothing when running controller examples in isolation mode.
        def render_template(*ignore_args); end
        # Do nothing when running controller examples in isolation mode.
        def render_partial(*ignore_args);  end
      end

      def self.extended(kls)
        Micronaut.configuration.trace { "In #{self} extended callback for #{kls}"}
        
        kls.send(:include, ActionController::TestProcess)
        kls.send(:include, InstanceMethods)
        kls.send(:include, Micronaut::Rails::Matchers::Controllers)

        kls.before do
          @controller = self.class.describes.new
          Micronaut.configuration.trace { "Enhancing #{@controller.inspect} with Rails controller extensions" }
          @controller.class.send :include, RenderOverrides
          @controller.class.send :include, ActionController::TestCase::RaiseActionExceptions
          @request = ActionController::TestRequest.new
          @controller.request = @request
          @response = ActionController::TestResponse.new
          @controller.params = {}
          @controller.send(:initialize_current_url)
          @response.session = @request.session
        end

      end

    end
  end
end
