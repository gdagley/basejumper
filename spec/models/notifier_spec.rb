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
    
    it "should be sent to user's email" do
      @mail.to.should include(@user.email)
    end
    
    it "should include a link to reset password" do
      @mail.body.should include("password_reset/edit?id=#{@user.perishable_token}")
    end
  end
end