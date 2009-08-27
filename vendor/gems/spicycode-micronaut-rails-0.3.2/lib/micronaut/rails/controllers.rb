require 'action_controller'
require 'action_controller/test_process'

module Micronaut
  module Rails
    module Controllers

      module InstanceMethods
        attr_reader :request, :response, :controller

        def route_for(options)
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
          ActionController::Routing::Routes.generate(options)
        end

        def params_from(method, path)
          ActionController::Routing::Routes.reload if ActionController::Routing::Routes.empty?
          ActionController::Routing::Routes.recognize_path(path, :method => method)
        end

      end

      module TemplateIsolationExtensions
        def file_exists?(ignore); true; end
        
        def render_file(*args)
          @first_render ||= args[0] unless args[0] =~ /^layouts/
        end
        
        def render(*args)
          return super if Hash === args.last && args.last[:inline]
          record_render(args[0])
        end
      
      private
      
        def record_render(opts)
          @_rendered ||= {}
          (@_rendered[:template] ||= opts[:file]) if opts[:file]
          (@_rendered[:partials][opts[:partial]] += 1) if opts[:partial]
        end

      end


      module RenderOverrides

        def render_views!
          @render_views = true
        end

        def rendering_views?
          @render_views
        end
        
        def render(options=nil, extra_options={}, &block)
          unless block_given?
            unless rendering_views?
              @template.extend TemplateIsolationExtensions
            end
          end
 
          super
        end

      end

      def self.extended(extended_behaviour)
        extended_behaviour.send :include, ::ActionController::TestProcess, InstanceMethods, ::Micronaut::Rails::Matchers::Controllers
        extended_behaviour.describes.send :include, RenderOverrides, ::ActionController::TestCase::RaiseActionExceptions

        extended_behaviour.before do
          @request = ::ActionController::TestRequest.new
          @response = ::ActionController::TestResponse.new
          @controller = self.class.describes.new

          @controller.request = @request
          @controller.params = {}
          @controller.send(:initialize_current_url)
        end

      end

    end
  end
end
