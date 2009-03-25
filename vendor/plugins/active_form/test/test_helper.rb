require 'rubygems'
require 'test/unit'

unless ENV['RAILS_VERSION'] then gem 'activerecord', '>= 2.1.0'
else gem 'activerecord', ENV['RAILS_VERSION'] end

require 'active_record'
require 'active_record/base'

plugin_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
require File.join(plugin_root, 'lib/active_form')

class Test::Unit::TestCase
  def assert_valid(model, message = nil)
    assert model.valid?, message
  end
  
  def assert_invalid(model, message = nil)
    assert !model.valid?, message
  end
end
