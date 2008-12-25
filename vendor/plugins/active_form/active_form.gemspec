Gem::Specification.new do |s|
  s.name    = 'active_form'
  s.version = '1.0.0'
  s.date    = '2008-09-08'
  
  s.summary = "Validations for Non Active Record Models"
  
  s.authors  = ['Christoph Schiessl']
  s.email    = 'c.schiessl@gmx.net'
  s.homepage = 'http://github.com/cs/active_form'
  
  s.has_rdoc = false
  s.add_dependency 'activerecord', ['>= 2.1.0']
  
  s.files = %w(init.rb lib lib/active_form.rb MIT-LICENCE Rakefile test)
  s.test_files = %w(test/test_helper.rb test/basic_test.rb)
end
