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
      @user = mock_model(User)
      User.stub!(:find_by_email).and_return(@user)
      @user.stub!(:deliver_password_reset_instructions!)
    end
    
    it "should look for user by email" do
      User.should_receive(:find_by_email).and_return(@user)
      post :create
    end
    
    it "should re-render form when no user is found" do
      User.stub!(:find_by_email).and_return(nil)
      post :create
      response.should render_template('show')
    end
    
    it "should deliver password reset instructions when user is found" do
      @user.should_receive(:deliver_password_reset_instructions!)
      post :create
    end
    
    it "should redirect to root after sending instructions" do
      post :create
      response.should redirect_to(root_path)
    end
  end
  
  describe "GET /password_reset/edit?id=SOME_PERISHABLE_TOKEN" do
    before(:each) do
      @user = mock_model(User)
      User.stub!(:find_using_perishable_token).and_return(@user)
    end
    
    it "should look for user using perishable token" do
      User.should_receive(:find_using_perishable_token).with('some_token').and_return(@user)
      get :edit, :id => 'some_token'
    end
    
    it "should redirect to root when user cannot be found" do
      User.stub!(:find_using_perishable_token).and_return(nil)
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
      @user = mock_model(User)
      @user.stub!(:password=)
      @user.stub!(:password_confirmation=)
      @user.stub!(:save).and_return(true)
      User.stub!(:find_using_perishable_token).and_return(@user)
    end
    
    def do_put
      put :update, :id => 'some_token', :user => {}      
    end
    
    it "should look for user using perishable token" do
      User.should_receive(:find_using_perishable_token).with('some_token').and_return(@user)
      put :update, :id => 'some_token', :user => {}      
    end
    
    it "should redirect to root when user cannot be found" do
      User.stub!(:find_using_perishable_token).and_return(nil)
      do_put
      response.should redirect_to(root_path)
    end
    
    it "should render password reset form when user cannot be updated" do
      @user.stub!(:save).and_return(false)
      do_put
      response.should render_template('edit')
    end
    
    it "should redirect to account when user is updated" do
      do_put
      response.should redirect_to(account_path)
    end    
  end
  
end
