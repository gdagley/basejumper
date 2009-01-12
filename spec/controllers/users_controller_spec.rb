require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
  describe "GET /signup" do
    it "should render the new user form" do
      get :new
      assigns(:user).should_not be_nil
    end
  end
  
  describe "POST /registration" do
    before(:each) do
      @user = mock_model(User, :admin= => true)
      User.stubs(:new).returns(@user)
      @user.stubs(:save).returns(true)
    end
    
    it "should re-render new user form when user is not saved" do
      @user.stubs(:save).returns(false)
      post :create
      response.should render_template("new")
    end
    
    it "should redirect to the account after user is saved" do
      post :create
      response.should redirect_to(account_path)
    end
  end
  
  describe "GET /account" do
    it "should require login" do
      get :show
      response.should redirect_to(login_path)
    end
    
    it "should load the current user" do
      user = mock_model(User)
      login_as(user)
      get :show
      assigns(:user).should == user
    end
  end
  
  describe "GET /account/edit" do
    it "should require login" do
      get :edit
      response.should redirect_to(login_path)
    end
    
    it "should load the current user" do
      user = mock_model(User)
      login_as(user)
      get :edit
      assigns(:user).should == user
    end
  end
  
  describe "PUT /account" do
    it "should require login" do
      put :update
      response.should redirect_to(login_path)
    end
    
    it "should re-render user form when user cannot be saved" do
      user = mock_model(User)
      login_as(user)
      user.stubs(:update_attributes).returns(false)
      put :update
      response.should render_template('edit')
    end
    
    it "should redirect to account after user is updated" do
      user = mock_model(User)
      login_as(user)
      user.stubs(:update_attributes).returns(true)
      put :update
      response.should redirect_to(account_path)
    end
    
  end

end