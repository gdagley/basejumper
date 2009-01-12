module AuthlogicSystem
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
        access_denied
        return false
      end
    end
    
    def access_denied
      store_location
      flash[:notice] = "You do not have access to this page"
      redirect_to login_path
    end
    
    def authorized?
      true
    end

    def require_no_user
      if current_user
        store_location
        flash[:notice] = "You must be logged out to access this page"
        redirect_to account_path
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
    
    def self.included(base)
      base.send :helper_method, :current_user, :current_user_session if base.respond_to? :helper_method
    end
    
end