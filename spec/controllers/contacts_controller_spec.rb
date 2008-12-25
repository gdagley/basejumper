require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ContactsController do

  describe "GET /contact" do
    it "should load the contact form" do
      get :show
      response.should render_template('show')
    end
  end

  describe "POST /contact" do
    before(:each) do
      @contact = mock_model(Contact)
      @contact.stub!(:valid?).and_return(true)
      Contact.stub!(:new).and_return(@contact)
      Notifier.stub!(:deliver_contact)
    end
    
    describe "with invalid contact info" do
      it "should re-render contact form" do
        @contact.should_receive(:valid?).and_return(false)
        post :create
        response.should render_template('show')
      end
    end
    
    describe "with valid contact info" do
      it "should deliver email" do
        Notifier.should_receive(:deliver_contact)
        post :create
      end
    
      it "should redirect to root" do
        post :create
        response.should redirect_to(root_path)
      end
    end
  end
end
