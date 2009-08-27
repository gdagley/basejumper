require File.expand_path(File.dirname(__FILE__) + "/../example_helper")

describe Micronaut::Rails do
  
  pending "should never include lib/autotest in the gemspec, as it breaks autotest for Micronaut - see #{ticket 4}
            PENDING due to jeweler changing the gemspec tasks..." do
    # We jump through hoops to make sure the Rake deprecation notice doesn't show up in the build (via stderr) or
    # in the gemspec itself
    silence_stream(STDERR) do
      @spec_string = `rake --silent gemspec`
    end
    @spec_string.gsub! /Gem::manage_gems is deprecated/, "" 
    gem_spec = eval(@spec_string)
    gem_spec.files.each { |f| f.should_not match(%r|lib/autotest|) }
  end
end