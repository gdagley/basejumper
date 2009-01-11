Comatose.configure do |config|
  # Includes AuthenticationSystem in the ComatoseController
  config.includes << :authlogic_system

  # admin 
  config.admin_title = "Comatose - TESTING"
  config.admin_sub_title = "Content for the rest of us..."

  # Includes AuthenticationSystem in the ComatoseAdminController
  config.admin_includes << :authlogic_system

  # Calls :require_user as a before_filter
  config.admin_authorization = :require_user
  # Returns the author name (login, in this case) for the current user
  config.admin_get_author do
    current_user.login
  end
end