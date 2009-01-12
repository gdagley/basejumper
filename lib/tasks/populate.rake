# See http://railscasts.com/episodes/126-populating-a-database for more info
namespace :db do
  desc "Erase and fill database"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [User].each(&:delete_all)

    User.populate(1) do |user|
      user.login              = 'admin'
      user.email              = 'admin@example.com'
      user.admin              = 1
      assign_defaults(user)
    end
    
    User.populate(121) do |user|
      user.login                 = Faker::Internet.user_name
      user.email                 = Faker::Internet.email(user.login)
      assign_defaults(user)
    end
  end
  
  def assign_defaults(user)
    # the password is 'password'
    user.crypted_password   = 'b5885f4b374d83ddeea483c603dc00ab435673932471ec7beef74aeb4199199287149d7972a15d016affa42ea4a181f61b778663f9127d4d1b338059a8281f6b'
    user.password_salt      = 'c720e5aedfe88247318488ecaad5576cd99e875c324a47039a15fe7b9205bee1499ae596a99c5f66e472bcb7f3d948743b418abce10a54416de68b3e0db7cd50'
    user.persistence_token  = User.unique_token
    user.perishable_token   = User.unique_token
    user.login_count        = 0
  end
end