class Admin::UsersController < ApplicationController
  before_filter :require_user
  
  layout 'admin'
  
  active_scaffold :user do |config|
    config.columns = [:login, :email, :password, :password_confirmation, :admin?, 
                      :created_at, :login_count, :last_request_at, 
                      :last_login_at, :current_login_at, :last_login_ip, :current_login_ip]
    config.columns[:admin?].form_ui = :checkbox
    config.list.sorting = { :created_at => :desc }
    config.list.columns.exclude :password, :password_confirmation, :last_request_at, :last_login_at, :current_login_at, :last_login_ip, :current_login_ip
    config.create.columns.exclude :login_count, :last_request_at, :last_login_at, :current_login_at, :last_login_ip, :current_login_ip
    config.update.columns.exclude :password, :password_confirmation, :login_count, :last_request_at, :last_login_at, :current_login_at, :last_login_ip, :current_login_ip
    config.show.columns.exclude :password, :password_confirmation
  end
  
  protected
    def authorized?
      current_user.admin?
    end
end
