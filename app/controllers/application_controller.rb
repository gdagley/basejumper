# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthlogicSystem # see lib/authlogic_system
  include ExceptionNotifiable
  
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  protected
    def render_500
      respond_to do |type|
        type.html { render :template => "static/500", :status => "500 Error" }
        type.all  { render :nothing => true, :status => "500 Error" }
      end
    end  
end
