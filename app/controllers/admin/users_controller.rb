class Admin::UsersController < ApplicationController
  layout 'admin'
  
  active_scaffold :user do |config|
    config.columns = [:login, :email, :password, :password_confirmation, :created_at]
    config.list.sorting = { :created_at => :desc }
    config.list.columns.exclude :password, :password_confirmation
    config.update.columns.exclude :password, :password_confirmation
    config.show.columns.exclude :password, :password_confirmation
  end
end
