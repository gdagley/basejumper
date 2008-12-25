class Notifier < ActionMailer::Base
  default_url_options[:host] = configatron.site_domain
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          configatron.accounts_email
    recipients    user.email
    sent_on       Time.now
    body          :user => user
  end
end