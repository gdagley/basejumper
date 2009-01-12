class AdminController < ApplicationController
  before_filter :require_user

  protected
    def authorized?
      current_user.admin?
    end  
end
