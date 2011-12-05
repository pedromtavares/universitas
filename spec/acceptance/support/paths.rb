module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    root_path
  end
  
  def login_page
    new_user_session_path 
  end
  
  def signup_page
    new_user_registration_path
  end
  
  def profile
    profile_path(User.first)
  end
  
  def other_user_profile
    profile_path(User.last)
  end
  
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
