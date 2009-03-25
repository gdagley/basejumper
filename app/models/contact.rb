class Contact < ActiveForm
  attr_accessor :name, :email, :subject, :comment
  
  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :subject
  validates_presence_of :comment
end