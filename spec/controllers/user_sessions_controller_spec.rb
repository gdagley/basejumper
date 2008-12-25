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
      UserSession.stub!(:find).and_return(nil)
      @user_session = mock_model(UserSession)
      UserSession.stub!(:new).and_return(@user_session)
    end

    it "should re-render login form when user session cannot be created" do
      @user_session.stub!(:save).and_return(false)
      post :create
      response.should render_template("new")
    end
    
    it "should redirect to the user's account after logging in" do
      @user_session.stub!(:save).and_return(true)
      post :create
      response.should redirect_to(account_path)
    end
  end
  
  describe "GET /logout" do
    before(:each) do
      @user_session = login_as(mock_model(User))
      @user_session.stub!(:destroy)
    end
    
    it "should destroy the current user session" do
      @user_session.should_receive(:destroy)
      get :destroy
    end
    
    it "should redirect to the root after logging out" do
      get :destroy
      response.should redirect_to(root_path)
    end
  end
end