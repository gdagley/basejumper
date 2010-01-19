ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'homepage'

  map.login        '/login',        :controller => 'user_sessions', :action => 'new'
  map.logout       '/logout',       :controller => 'user_sessions', :action => 'destroy'
  map.signup       '/signup',       :controller => 'users',         :action => 'new'
  map.registration '/registration', :controller => 'users',         :action => 'create'
  
  map.resource  :user_session
  map.resource  :password_reset
  map.resource  :account, :controller => 'users'
  map.resource  :web_contact
  map.resources :users
  
  map.admin '/admin', :controller => 'admin'
  map.namespace(:admin) do |admin|
    admin.with_options(:active_scaffold => true) do |admin_scaffold|
      admin_scaffold.resources :users
    end
  end
  
  map.static '/:action', :controller => 'static'
end
