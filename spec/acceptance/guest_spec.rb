require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guest Navigation", %q{
  In order to use the application
  as a guest user
  I want to be able to browse through user profiles and courses without being asked to log in.
} do

  background do
    few_users_registered
  end

  scenario "Visiting user index" do
    visit users_page
    page.should_not have_content("You need to sign in or sign up before continuing.")
  end

	scenario "Visiting user profiles" do
		visit other_user_profile
		page.should_not have_content("You need to sign in or sign up before continuing.")
		page.should_not have_content("Follow this user")
		page.should_not have_content("Unfollow this user")
	end
  
  scenario "Visiting courses index" do
		visit courses_page
    page.should_not have_content("You need to sign in or sign up before continuing.")
  end
  
  scenario "Visiting a course page" do
		visit course_page(other_course)
		page.should_not have_content("You need to sign in or sign up before continuing.")
    page.should_not have_button("Enter this course")
  end

	scenario "Visiting the dashboard or trying to get to the course creation form will screw you up" do
		visit dashboard
		page.should have_content("You need to sign in or sign up before continuing.")
		visit course_creation_page
		page.should have_content("You need to sign in or sign up before continuing.")
	end
end
