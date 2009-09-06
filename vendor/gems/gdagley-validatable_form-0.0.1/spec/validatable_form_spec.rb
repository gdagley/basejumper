require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe ValidatableForm do
  before(:all) do
    class ContactForm < ValidatableForm
      form_fields :name, :email
      validates_presence_of :name
      validates_presence_of :email
    end
    
    class EmptyForm < ValidatableForm
    end
  end
  
  it "should register the form fields as attributes" do
    ContactForm.new.respond_to?(:name).should be_true
  end
  
  it "should not register the form fields from other classes as attributes" do
    EmptyForm.new.respond_to?(:name).should be_false
  end
  
  it "should allow initializing attributes with a hash" do
    f = ContactForm.new(:name => "John Doe", :email => "jdoe@example.com")    
    f.name.should == "John Doe"
    f.email.should == "jdoe@example.com"
  end
  
  it "should always be a new record" do
    ContactForm.new.should be_new_record
  end
  
  it "should not have an id" do
    ContactForm.new.id.should be_nil
  end
end