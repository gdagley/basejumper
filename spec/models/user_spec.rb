require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe User do
  describe "password reset" do
    before(:each) do
      @user = User.new
      @user.stub!(:reset_perishable_token!)
      Notifier.stub!(:deliver_password_reset_instructions)
    end
    
    it "should reset the perishable token" do
      @user.should_receive(:reset_perishable_token!)
      @user.deliver_password_reset_instructions!
    end
    
    it "should deliver reset instructions" do
      Notifier.should_receive(:deliver_password_reset_instructions).with(@user)
      @user.deliver_password_reset_instructions!      
    end
  end
end