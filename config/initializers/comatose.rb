Comatose.configure do |config|
  # Includes AuthenticationSystem in the ComatoseController
  config.includes << :authlogic_system

  # admin 
  config.admin_title = "Comatose - TESTING"
  config.admin_sub_title = "Content for the rest of us..."

  # Includes AuthenticationSystem in the ComatoseAdminController
  config.admin_includes << :authlogic_system

  # before_filter to check authorization
  config.admin_authorization do
    current_user && current_user.admin? ? true : access_denied
  end
  # Returns the author name (login, in this case) for the current user
  config.admin_get_author do
    current_user.login
  end
end