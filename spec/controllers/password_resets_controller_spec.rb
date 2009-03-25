require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PasswordResetsController do
  describe "GET /password_reset" do
    it "should render password reset form" do
      get :show
      response.should render_template('show')
    end
  end
  
  describe "POST /password_reset" do
    before(:each) do
      @user = stub_model(User)
      User.stubs(:find_by_email).returns(@user)
      @user.stubs(:deliver_password_reset_instructions!)
    end
    
    it "should look for user by email" do
      User.expects(:find_by_email).returns(@user)
      post :create
    end
    
    it "should re-render form when no user is found" do
      User.stubs(:find_by_email).returns(nil)
      post :create
      response.should render_template('show')
    end
    
    it "should deliver password reset instructions when user is found" do
      @user.expects(:deliver_password_reset_instructions!)
      post :create
    end
    
    it "should redirect to root after sending instructions" do
      post :create
      response.should redirect_to(root_path)
    end
  end
  
  describe "GET /password_reset/edit?id=SOME_PERISHABLE_TOKEN" do
    before(:each) do
      @user = stub_model(User)
      User.stubs(:find_using_perishable_token).returns(@user)
    end
    
    it "should look for user using perishable token" do
      User.expects(:find_using_perishable_token).with('some_token').returns(@user)
      get :edit, :id => 'some_token'
    end
    
    it "should redirect to root when user cannot be found" do
      User.stubs(:find_using_perishable_token).returns(nil)
      get :edit
      response.should redirect_to(root_path)
    end
    
    it "should render password reset form when user is found" do
      get :edit
      response.should render_template('edit')
    end
  end
  
  describe "PUT /password_reset?id=SOME_PERISHABLE_TOKEN" do
    before(:each) do
      @user = stub_model(User)
      @user.stubs(:password=)
      @user.stubs(:password_confirmation=)
      @user.stubs(:save).returns(true)
      User.stubs(:find_using_perishable_token).returns(@user)
    end
    
    def do_put
      put :update, :id => 'some_token', :user => {}      
    end
    
    it "should look for user using perishable token" do
      User.expects(:find_using_perishable_token).with('some_token').returns(@user)
      put :update, :id => 'some_token', :user => {}      
    end
    
    it "should redirect to root when user cannot be found" do
      User.stubs(:find_using_perishable_token).returns(nil)
      do_put
      response.should redirect_to(root_path)
    end
    
    it "should render password reset form when user cannot be updated" do
      @user.stubs(:save).returns(false)
      do_put
      response.should render_template('edit')
    end
    
    it "should redirect to account when user is updated" do
      do_put
      response.should redirect_to(account_path)
    end    
  end
  
end
