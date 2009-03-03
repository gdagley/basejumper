log_buddy_logger = Rails.env.test? ? Logger.new(STDOUT) : Rails.logger
LogBuddy.init :default_logger => log_buddy_logger