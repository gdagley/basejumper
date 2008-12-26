class Notifier < ActionMailer::Base
  default_url_options[:host] = configatron.site_domain
  
  def password_reset_instructions(user)
    subject       "Password Reset Instructions"
    from          configatron.accounts_email
    recipients    user.email
    sent_on       Time.now
    body          :user => user
  end
  
  def contact(contact)
    subject       contact.subject
    from          contact.email 
    recipients    configatron.info_email
    sent_on       Time.now
    body          :contact => contact
  end
end