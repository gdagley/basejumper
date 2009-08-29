begin
  config.gem "less"
  require 'less'
rescue LoadError
  puts "Please install the Less gem, `gem install less`."
end

case Rails.env
when "test"
  # Do nothing
when "production"
  # Compile less when the application loads
  config.after_initialize do
    LessForRails.run(:compress => true)
  end
else
  # Compile less on every request
  ActionController::Base.before_filter { LessForRails.run(:compress => true) }
end