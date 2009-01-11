require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "password reset" do
    before(:each) do
      @user = User.new
      @user.stubs(:reset_perishable_token!)
      Notifier.stubs(:deliver_password_reset_instructions)
    end
    
    it "should reset the perishable token" do
      @user.expects(:reset_perishable_token!)
      @user.deliver_password_reset_instructions!
    end
    
    it "should deliver reset instructions" do
      Notifier.expects(:deliver_password_reset_instructions).with(@user)
      @user.deliver_password_reset_instructions!      
    end
  end
end