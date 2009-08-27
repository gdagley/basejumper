begin 
  require 'jeweler' 
  Jeweler::Tasks.new do |s| 
    s.name = "micronaut-rails" 
    s.summary = "An excellent replacement for the wheel on rails..."
    s.email = "chad@spicycode.com" 
    s.homepage = "http://github.com/spicycode/micronaut-rails" 
    s.description = "An excellent replacement for the wheel on rails..."
    s.authors = ["Chad Humphries"] 
    s.files =  FileList["[A-Z]*", "{bin,lib,examples}/**/*"] 
    s.add_dependency "actionpack", '>= 2.3.0'
    s.add_dependency "spicycode-micronaut", '>= 0.2.7'
  end 
rescue LoadError 
  puts "Jeweler, or one of its dependencies, is not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com" 
end

gem 'spicycode-micronaut'
require 'micronaut/rake_task'

desc "Run all micronaut examples"
Micronaut::RakeTask.new :examples do |t|
  t.pattern = "examples/**/*_example.rb"
end

namespace :examples do
  
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = %[--exclude "examples/*,gems/*,db/*,/Library/Ruby/*,config/*" --text-summary  --sort coverage]
  end

end

task :default => 'examples:coverage'
