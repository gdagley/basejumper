# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.first
unless admin
  admin = User.create(:email => 'admin@email.com', :password => 'monkey', :password_confirmation => 'monkey')
end
admin.roles << :admin
admin.save
