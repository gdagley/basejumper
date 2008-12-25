require 'rubygems'
require 'test/spec'
require 'active_support'
require 'action_view/helpers/tag_helper'
require 'action_view/helpers/url_helper'
require 'seo_helper'

describe "SeoHelper" do
  describe "page_title" do
    include ActionView::Helpers::TagHelper
    include SeoHelper

    it "should create a title with h1" do
      page_title('Hello World').should == '<h1>Hello World</h1>'
    end

    it "should create a title with an alternate tag" do
      page_title('Hello World', :h3).should == '<h3>Hello World</h3>'
    end
        
    it "should set the content for html page title" do
      page_title('Hello World')
    	@content_for_html_page_title.should == 'Hello World'
    end
  end

  describe "html_title" do
    include ActionView::Helpers::TagHelper
    include SeoHelper
  
    it "should create an html title" do
      html_title('SiteName').should == '<title>SiteName</title>'
    end

    it "should create an html title with content for html page title" do
    	@content_for_html_page_title = 'Page Title'
      html_title('SiteName').should == '<title>Page Title : SiteName</title>'
    end


    it "should create an html title specified delimiter" do
    	@content_for_html_page_title = 'Page Title'
      html_title('SiteName', '|').should == '<title>Page Title | SiteName</title>'
    end
  end

  describe "meta_tags" do
    include ActionView::Helpers::TagHelper
    include SeoHelper

    it "should not create meta tags when there is no meta info" do
      meta = nil
      meta_tags(nil).should.be.nil
    end

    it "should create meta tags when there is meta info" do
      meta = {:description => 'This is the description'}
      meta_tags(meta).should == %{<meta content="This is the description" name="description" />}
    end

    it "should multiple meta tags when there is more meta info" do
      meta = {:description => 'This is the description', :keywords => 'these are keywords'}
      meta_tags(meta).should.include(%{<meta content="these are keywords" name="keywords" />})
      meta_tags(meta).should.include(%{<meta content="This is the description" name="description" />})
    end
  end
  
  describe "breadcrumb_trail" do
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::UrlHelper
    include SeoHelper

    it "should create a breadcrumb trail" do
      crumbs = [{:name => 'Home', :link => 'http://test.host/'},
                {:name => 'Shops'}]
      breadcrumb_trail(crumbs).should == %[<div class="breadcrumbs"><a href="http://test.host/">Home</a> &gt; Shops</div>]
    end

    it "should create a breadcrumb trail with a specified tag" do
      crumbs = [{:name => 'Home', :link => 'http://test.host/'},
                {:name => 'Shops'}]
      breadcrumb_trail(crumbs, :span).should == %[<span class="breadcrumbs"><a href="http://test.host/">Home</a> &gt; Shops</span>]
    end

    it "should create a breadcrumb trail with specified delimiter" do
      crumbs = [{:name => 'Home', :link => 'http://test.host/'},
                {:name => 'Shops'}]
      breadcrumb_trail(crumbs, :div, '|').should == %[<div class="breadcrumbs"><a href="http://test.host/">Home</a> | Shops</div>]
    end

    it "should not create an empty breadcrumb trail" do
      crumbs = []
      breadcrumb_trail(crumbs).should.be.nil
    end
  end

end
