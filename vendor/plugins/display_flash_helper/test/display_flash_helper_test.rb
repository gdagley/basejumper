require File.dirname(__FILE__) + '/../lib/display_flash_helper'
require 'rubygems'
require 'test/spec'
require 'mocha'

describe "ApplicationHelper" do
  include DisplayFlashHelper
  
  attr_reader :flash
  
  def setup 
    @flash = {}
  end
  
  it "should create nothing when flash is empty" do
  	display_flash.should.be.empty
  end

  it "should create warning flash" do
  	flash[:warning] = "This is a warning"
  	self.expects(:content_tag).with(:div, "This is a warning", :class => "warning").returns("WARNING")
    self.expects(:content_tag).with(:div, "WARNING", :id => "flash")
  	display_flash
  end

  it "should create notice flash" do
  	flash[:notice] = "This is a notice"
  	self.expects(:content_tag).with(:div, "This is a notice", :class => "notice").returns("NOTICE")
    self.expects(:content_tag).with(:div, "NOTICE", :id => "flash")
  	display_flash
  end

  it "should create error flash" do
  	flash[:error] = "This is an error"
  	self.expects(:content_tag).with(:div, "This is an error", :class => "error").returns("ERROR")
    self.expects(:content_tag).with(:div, "ERROR", :id => "flash")
  	display_flash
  end
  
  it "should create multiple flash messages if multiple set" do
    flash[:error] = "This is an error"
    flash[:notice] = "This is a notice"
    self.expects(:content_tag).with(:div, "This is an error", :class => "error").returns("ERROR")
    self.expects(:content_tag).with(:div, "This is a notice", :class => "notice").returns("NOTICE")
    self.expects(:content_tag).with(:div, "ERROR\nNOTICE", :id => "flash")
    display_flash
  end

end
