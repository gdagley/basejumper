require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomepageController do

  describe "GET /" do
    it "should be successful" do
      get :index
      response.should be_success
    end
  end
end
