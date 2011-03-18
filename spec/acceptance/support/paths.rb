module NavigationHelpers
  # Put helper methods related to the paths in your application here.

  def homepage
    "/"
  end
  
  def dashboard
    "/dashboard"
  end
  
  def login_page
    "/users/sign_in"
  end
  
  def signup_page
    "/users/sign_up"
  end
  
  def users_page
    "/users"
  end
  
  def profile_page
    "/#{User.first.login}"
  end
  
  def edit_profile_page
    "/profile/edit"
  end
  
  def other_user_profile
    "/#{User.last.login}"
  end

	def groups_page
		groups_path
	end
	
	def group_page(group)
		group_path(group)
	end
	
	def group_creation_page
		new_group_path
	end
  
end

RSpec.configuration.include NavigationHelpers, :type => :acceptance
