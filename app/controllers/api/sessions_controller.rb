# http://matteomelani.wordpress.com/2011/10/17/authentication-for-mobile-devices/
# https://github.com/plataformatec/devise/wiki/How-To:-Simple-Token-Authentication-Example

# GET
# http://localhost:3000/courses.json?auth_token=<put your token here>
#

#
# POST
# http://localhost:3000/api/sessions.json
# Content-Type:application/json
# {
#   "email":"user@email.com",
#   "password":"<password>"
# }
#
# return: {"token":"xXZtgecrnqCATjQ2o7cq"}
#

class Api::SessionsController < Api::BaseApiController
  def create
    email = params[:email]
    password = params[:password]

    if request.format != :json
        render :status=>406, :json=>{:message=>"The request must be json"}
        return
    end

    if email.nil? or password.nil?
      render :status=>400, :json=>{:message=>"The request must contain the user email and password."}
      return
    end

    @user=User.find_by_email(email.downcase)

    if @user.nil?
      logger.info("User #{email} failed sign-in, user cannot be found.")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
      return
    end

    @user.ensure_authentication_token!
    @user.save!

    if not @user.valid_password?(password)
      logger.info("User #{email} failed sign-in, password \"#{password}\" is invalid")
      render :status=>401, :json=>{:message=>"Invalid email or password."}
    else
      render :status=>200, :json=>{:token=>@user.authentication_token}
    end
  end

  def destroy
    @user=User.find_by_authentication_token(params[:id])
    if @user.nil?
      logger.info("Token not found.")
      render :status=>404, :json=>{:message=>"Invalid token."}
    else
      @user.reset_authentication_token!
      render :status=>200, :json=>{:token=>params[:id]}
    end
  end

end
