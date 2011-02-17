module HelperMethods
  
# ------ User related

  def primary_user
    @primary ||= User.first
  end

  def other_user
    @other ||= User.last
  end

  def users
    @users ||= []
  end
  
  def logged_in_as(login)
    user = User.find_by_login(login)
    users << Factory(:user, :login => login, :name => "Default User") unless user
    visit login_page
    fill_in("Login", :with => login)
    fill_in("Password", :with => "123456")
    click_button("Login")
  end
  
  def few_users_registered
    20.times do
      new_user = Factory(:user)
      new_user.update_status("Hello from #{new_user.name}")
      users << new_user
    end
  end
  
  def user_following_other_users
    users[0..2].each do |user|
      primary_user.follow!(user)
    end
  end
  
  def user_has_some_followers
    users[0..2].each do |user|
      user.follow!(primary_user)
    end
  end
  
  def follow_other_user
    primary_user.follow!(other_user)
  end

# ------ Course related

	def default_course
		@default_course ||= Course.create(:teacher => User.find_by_login("default"), :name => "Test Course")
	end
	
	def other_course
		@other_course ||= Factory(:course)
	end
  
end

RSpec.configuration.include HelperMethods, :type => :acceptance
