# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include ExceptionNotifiable
  
  helper :all
  helper_method :current_user_session, :current_user
  filter_parameter_logging :password, :password_confirmation

  protected
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end
  
    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.record
    end
    
    def require_user
      unless current_user && authorized?
        store_location
        flash[:notice] = "You do not have access to this page"
        redirect_to login_url
        return false
      end
    end
    
    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_url
        return false
      end
    end
  
    def store_location
      session[:return_to] = request.request_uri
    end
  
    def redirect_back_or_default(default)
      redirect_to(session[:return_to] || default)
      session[:return_to] = nil
    end
    
    def authorized?
      true
    end
    
    def render_500
      respond_to do |type|
        type.html { render :template => "static/500", :status => "500 Error" }
        type.all  { render :nothing => true, :status => "500 Error" }
      end
    end  
end
