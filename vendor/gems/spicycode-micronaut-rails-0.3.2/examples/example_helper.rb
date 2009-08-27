lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'rubygems'

begin
  gem "spicycode-micronaut", ">= 0.2.2"
rescue LoadError => e
  puts "\nERROR - This version of micronaut-rails requires micronaut 0.2.2 or higher."
  puts "gem install spicycode-micronaut --version 0.2.2"
  puts
  exit(1)
end
require 'action_controller'
require 'micronaut'
require 'micronaut-rails'

gem "mocha"

module Micronaut  
  module Matchers
    def fail
      raise_error(::Micronaut::Expectations::ExpectationNotMetError)
    end

    def fail_with(message)
      raise_error(::Micronaut::Expectations::ExpectationNotMetError, message)
    end
  end
end

def remove_last_describe_from_world
  Micronaut.world.behaviours.pop
end

class DummyFormatter <  Micronaut::Formatters::BaseTextFormatter; end

def dummy_reporter
  DummyFormatter.new({}, StringIO.new)
end

def use_color?
  !ENV.has_key?('TM_MODE')
end

# allow including links to lighthouse tickets in examples, for regression tests, pending features, etc.
def ticket(number)
  %[http://relevance.lighthouseapp.com/projects/22819-micronaut/tickets/#{number}]
end

Micronaut.configure do |config|
  config.mock_with :mocha
  config.color_enabled = use_color?
  config.formatter = :documentation
  config.filter_run :focused => true
end
