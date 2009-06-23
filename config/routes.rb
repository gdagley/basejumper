ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'homepage'

  map.login '/login', :controller => 'user_sessions', :action => 'new'
  map.logout '/logout', :controller => 'user_sessions', :action => 'destroy'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.registration '/registration', :controller => 'users', :action => 'create'
  map.admin '/admin', :controller => 'admin'
  
  map.resource :account, :controller => 'users'
  map.resource :password_reset
  map.resources :users
  map.resource :user_session
  map.resource :contact
  
  map.namespace(:admin) do |admin|
    admin.with_options(:active_scaffold => true) do |admin_scaffold|
      admin_scaffold.resources :users
    end
  end
end
