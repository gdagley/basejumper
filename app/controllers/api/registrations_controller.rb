# http://jessewolgamott.com/blog/2012/01/19/the-one-with-a-json-api-login-using-devise/

class Api::RegistrationsController < Api::BaseController
  def create
    user = User.new(params[:user])
    if user.save
      render :json=> user.as_json(:auth_token=>user.authentication_token, :email=>user.email), :status=>201
      return
    else
      warden.custom_failure!
      render :json=> user.errors, :status=>422
    end
  end
end