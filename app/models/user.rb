class User < ActiveRecord::Base
  include RoleModel

  # declare the valid roles -- do not change the order if you add more
  # roles later, always append them at the end!
  roles :admin

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, token_authenticatable,
          :registerable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :roles
end
