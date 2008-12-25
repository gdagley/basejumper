require File.dirname(__FILE__) + '/../lib/pretty_buttons'
require 'rubygems'
require 'test/spec'
require 'mocha'

describe "PrettyButtons" do
  describe "creating buttons" do
    include PrettyButtons

    it "should create button marked up for pretty button css" do
      img_tag = "<img src='icons/icon.gif' />"
      self.expects(:image_tag).with('icons/icon.gif').returns(img_tag)
      self.expects(:content_tag).with(:button, "#{img_tag} Label", {:type => 'submit', :class => "button "})
    
      pretty_button("Label", {:icon_path => "icons/icon.gif"})
    end

    it "should create button marked up for pretty button css without icon" do
      self.expects(:content_tag).with(:button, " Label", {:type => 'submit', :class => "button "})
    
      pretty_button("Label")
    end
    
    it "should create button marked up for positive pretty button css" do
      img_tag = "<img src='icons/tick.gif' />"
      self.expects(:image_tag).with('icons/tick.gif').returns(img_tag)
      self.expects(:content_tag).with(:button, "#{img_tag} Label", {:type => 'submit', :class => "button positive"})
    
      pretty_positive_button("Label")
    end
  
    it "should create button marked up for positive pretty button css" do
      img_tag = "<img src='icons/another.gif' />"
      self.expects(:image_tag).with('icons/another.gif').returns(img_tag)
      self.expects(:content_tag).with(:button, "#{img_tag} Label", {:type => 'submit', :class => "button positive"})
    
      pretty_positive_button("Label", {:icon_path => 'icons/another.gif'})
    end
  
    it "should create button marked up for negative pretty button css" do
      img_tag = "<img src='icons/cross.gif' />"
      self.expects(:image_tag).with('icons/cross.gif').returns(img_tag)
      self.expects(:content_tag).with(:button, "#{img_tag} Label", {:type => 'submit', :class => "button negative"})
    
      pretty_negative_button("Label")
    end
  end
  
  describe "creating links" do
    include PrettyButtons
    
    it "should create link marked up for pretty button css" do
      img_tag = "<img src='icons/icon.gif' />"
      self.expects(:image_tag).with('icons/icon.gif').returns(img_tag)
      self.expects(:link_to).with("#{img_tag} Label", "#", {:class => "button "})
    
      pretty_button_link("Label", "#", {:icon_path => "icons/icon.gif"})
    end
    
    it "should create link marked up for pretty button css without icon" do
      self.expects(:link_to).with(" Label", "#", {:class => "button "})
    
      pretty_button_link("Label", "#")
    end
    
    it "should create link marked up for positive pretty button css" do
      img_tag = "<img src='icons/tick.gif' />"
      self.expects(:image_tag).with('icons/tick.gif').returns(img_tag)
      self.expects(:link_to).with("#{img_tag} Label", "#", {:class => "button positive"})
    
      pretty_positive_button_link("Label", "#")
    end

    it "should create link marked up for positive pretty button css with alternate icon" do
      img_tag = "<img src='icons/another.gif' />"
      self.expects(:image_tag).with('icons/another.gif').returns(img_tag)
      self.expects(:link_to).with("#{img_tag} Label", "#", {:class => "button positive"})
    
      pretty_positive_button_link("Label", "#", {:icon_path => 'icons/another.gif'})
    end
        
    it "should create link marked up for negative pretty button css" do
      img_tag = "<img src='icons/cross.gif' />"
      self.expects(:image_tag).with('icons/cross.gif').returns(img_tag)
      self.expects(:link_to).with("#{img_tag} Label", "#", {:class => "button negative"})
    
      pretty_negative_button_link("Label", "#")
    end

    it "should preserve html_options passed to link" do
      img_tag = "<img src='icons/cross.gif' />"
      self.expects(:image_tag).with('icons/cross.gif').returns(img_tag)
      self.expects(:link_to).with("#{img_tag} Label", "#", {:class => "button negative", :confirm => 'Are you sure?'})
    
      pretty_negative_button_link("Label", "#", {:confirm => 'Are you sure?'})
    end
        
  end
end
