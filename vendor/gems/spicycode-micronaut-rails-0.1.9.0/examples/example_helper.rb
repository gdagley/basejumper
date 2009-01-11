lib_path = File.expand_path(File.dirname(__FILE__) + "/../lib")
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include?(lib_path)

require 'micronaut/rails/version'
begin
  gem "spicycode-micronaut", Micronaut::Rails::Version::MICRONAUT_VERSION_STRING
rescue LoadError => e
  puts "\nERROR - This version of micronaut-rails requires micronaut #{Micronaut::Rails::Version::MICRONAUT_VERSION_STRING} - please install with: \n"
  puts "gem install spicycode-micronaut --version #{Micronaut::Rails::Version::MICRONAUT_VERSION_STRING}\n"
  puts
  exit(1)
end
require 'micronaut'
require 'micronaut-rails'
require 'rubygems'
gem :mocha

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
  config.profile_examples = false
  config.filter_run :focused => true
  config.autorun!
end