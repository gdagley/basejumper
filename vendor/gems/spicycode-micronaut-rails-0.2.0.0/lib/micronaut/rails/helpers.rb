module Micronaut
  module Rails
    module Helpers

      class HelperController < ActionController::Base; end

      module InstanceMethods

        class HelperObject < ActionView::Base
          def protect_against_forgery?
            false
          end

          def session=(session)
            @session = session
          end

          def request=(request)
            @request = request
          end

          def flash=(flash)
            @flash = flash
          end

          def params=(params)
            @params = params
          end

          def controller=(controller)
            @controller = controller
          end

          private
          attr_reader :session, :request, :flash, :params, :controller
        end

        def helper
          @helper_object ||= returning HelperObject.new do |helper_object|
            if self.class.describes.class == Module
              helper_object.extend self.class.describes
            end
          end
        end

        def params
          request.parameters
        end

        def flash
          response.flash
        end

        def session
          response.session
        end

        def method_missing(sym, *args)
          if helper.respond_to?(sym)
            helper.send(sym, *args)
          else
            super
          end
        end

      end

      def self.extended(kls)
        kls.send(:include, InstanceMethods)

        kls.send(:attr_reader, :request, :response)

        ActionView::Base.included_modules.reverse.each do |mod|
          kls.send(:include, mod) if mod.parents.include?(ActionView::Helpers)
        end

        kls.before do
          @controller = HelperController.new
          @request = ActionController::TestRequest.new
          @response = ActionController::TestResponse.new
          @response.session = @request.session
          @controller.request = @request
          @flash = ActionController::Flash::FlashHash.new
          @response.session['flash'] = @flash

          ActionView::Helpers::AssetTagHelper::reset_javascript_include_default

          helper.session = @response.session
          helper.request = @request
          helper.flash = @flash
          helper.params = params
          helper.controller = @controller
        end

      end

    end
  end
end