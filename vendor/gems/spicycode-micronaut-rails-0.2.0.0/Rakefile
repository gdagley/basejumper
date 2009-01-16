require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require File.join(File.dirname(__FILE__), *%w[. lib micronaut rails version])

GEM = "micronaut-rails"
GEM_VERSION = Micronaut::Rails::Version::STRING
AUTHOR = "Chad Humphries"
EMAIL = "chad@spicycode.com"
HOMEPAGE = "http://github.com/spicycode/micronaut-rails"
SUMMARY = "An excellent replacement for the wheel, Rails edition."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", "RSPEC-LICENSE"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  s.bindir = 'bin'
  s.require_path = 'lib'
  s.autorequire = GEM
  s.add_dependency "actionpack", '>= 2.2.2'
  s.add_dependency "spicycode-micronaut", Micronaut::Rails::Version::MICRONAUT_VERSION_STRING
  s.files = %w(LICENSE README RSPEC-LICENSE Rakefile) + Dir.glob("{lib,examples}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "Create a gemspec file"
task :make_gemspec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Print the gemspec to stdout"
task :puts_gemspec do
  puts spec.to_ruby
end

desc 'Run all examples'
task :examples do
  examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
  ruby examples.join(" ")
end

namespace :examples do
  
  desc "List files that don't have examples"
  task :untested do
    code = Dir["lib/**/*.rb"].map { |g| Dir.glob(g) }.flatten
    examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
    examples.map! { |f| f =~ /examples\/(.*)_example/; "#{$1}.rb" }
    missing_examples = (code - examples)
    puts
    puts "The following files seem to be missing their examples:"
    missing_examples.each do |missing|
      puts "  #{missing}"
    end
  end

  desc "Run all examples using rcov"
  task :coverage do
    examples = Dir["examples/**/*_example.rb"].map { |g| Dir.glob(g) }.flatten
    result = system "rcov --exclude \"examples/*,gems/*,db/*,/Library/Ruby/*,config/*\" --text-summary  --sort coverage --no-validator-links #{examples.join(' ')}"
    fail_build unless result
  end

  def fail_build
    puts
    puts "-" * 79
    puts "Build Failed"
    puts "-" * 79
    abort
  end

  desc "Delete coverage artifacts" 
  task :clean_coverage do
    rm_rf Dir["coverage/**/*"]
  end

end

task :default => 'examples:coverage'
task :clobber_package => 'examples:clean_coverage'
