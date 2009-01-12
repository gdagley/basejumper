require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UserSessionsController do
  describe "GET /login" do
    it "should render login form" do
      get :new
      response.should render_template("new")
    end
  end
  
  describe "POST /user_session" do
    before(:each) do
      UserSession.stubs(:find).returns(nil)
      @user_session = mock_model(UserSession)
      UserSession.stubs(:new).returns(@user_session)
    end

    it "should re-render login form when user session cannot be created" do
      @user_session.stubs(:save).returns(false)
      post :create
      response.should render_template("new")
    end
    
    it "should redirect to the user's account after logging in" do
      @user_session.stubs(:save).returns(true)
      post :create
      response.should redirect_to(account_path)
    end
  end
  
  describe "GET /logout" do
    before(:each) do
      @user_session = login_as(mock_model(User))
      @user_session.stubs(:destroy)
    end
    
    it "should destroy the current user session" do
      @user_session.expects(:destroy)
      get :destroy
    end
    
    it "should redirect to the root after logging out" do
      get :destroy
      response.should redirect_to(root_path)
    end
  end
end