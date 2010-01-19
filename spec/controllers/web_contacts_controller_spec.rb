require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe WebContactsController do

  describe "GET /web_contact" do
    it "should load the contact form" do
      get :show
      response.should render_template('show')
    end
  end

  describe "POST /web_contact" do
    before(:each) do
      @contact = WebContact.new
      @contact.stubs(:valid?).returns(true)
      WebContact.stubs(:new).returns(@contact)
      Notifier.stubs(:deliver_contact)
    end
    
    describe "with invalid contact info" do
      it "should re-render contact form" do
        @contact.expects(:valid?).returns(false)
        post :create
        response.should render_template('show')
      end
    end
    
    describe "with valid contact info" do
      it "should deliver email" do
        Notifier.expects(:deliver_contact)
        post :create
      end
    
      it "should redirect to root" do
        post :create
        response.should redirect_to(root_path)
      end
    end
  end
end
