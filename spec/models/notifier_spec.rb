require File.dirname(__FILE__) + '/../spec_helper'

describe Notifier do
  describe "sending password reset instructions" do
    before(:each) do
      @user = mock_model(User, :email => 'user@example.com', :perishable_token => 'some_token')
      @mail = Notifier.create_password_reset_instructions(@user)
    end
    
    it "should have a subject" do
      @mail.subject.should == "Password Reset Instructions"
    end
    
    it "should be from 'accounts' email address" do
      @mail.from.should include(configatron.accounts_email)
    end
    
    fit "should be sent to user's email" do
      @mail.to.should include(@user.email)
    end
    
    it "should include a link to reset password" do
      @mail.body.should include("password_reset/edit?id=#{@user.perishable_token}")
    end
  end
  
  describe "website contact form" do
    before(:each) do
      @contact = mock_model(Contact,  :name => 'Joe Smith', 
                                      :email => 'user@example.com', 
                                      :subject => 'I know a guy', 
                                      :comment => 'Lorem ipsum ...')
      @mail = Notifier.create_contact(@contact)    
    end
  
    it "should have a subject" do
      @mail.subject.should == @contact.subject
    end
  
    it "should be from contact email address" do
      @mail.from.should include(@contact.email)
    end
  
    it "should be sent to 'info' email" do
      @mail.to.should include(configatron.info_email)
    end
  
    it "should include contact's name" do
      @mail.body.should include(@contact.name)
    end

    it "should include contact's comment" do
      @mail.body.should include(@contact.comment)
    end
  end
end