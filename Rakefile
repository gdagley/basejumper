# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'
require File.join(RAILS_ROOT, "vendor/gems/spicycode-micronaut-0.3.0/lib/micronaut/rake_task")

desc "Run all examples"
Micronaut::RakeTask.new :examples do |t|
  t.pattern = "examples/**/*_example.rb"
end

namespace :examples do
  desc "Run all micronaut examples using rcov"
  Micronaut::RakeTask.new :coverage do |t|
    t.pattern = "examples/**/*_example.rb"
    t.rcov = true
    t.rcov_opts = "--exclude \"examples/*,gems/*,lib/authenticated*,db/*,/Library/Ruby/*,config/*\" --rails --text-summary  --sort coverage" 
  end
end

Rake.application.instance_variable_get('@tasks').delete('default')
task :default => ['db:test:prepare', 'examples:coverage']
