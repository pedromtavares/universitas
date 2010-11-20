require File.dirname(__FILE__) + '/acceptance_helper'

feature "User profile", %q{
  In order to access my profile information and modify it
  as a registered user
  I want to be able to see my followers as well as the users I follow
  	And I want to be able to edit my profile
} do

  background do
    logged_in_as("default")
    few_users_registered
  end

  scenario "Profile information" do
    user_following_other_users
    user_has_some_followers
    visit profile_page
    page.should have_content(primary_user.email)
    primary_user.followers.each do |follower|
      page.should have_content(follower.name)
    end
    primary_user.following.each do |following|
      page.should have_content(following.name)
    end
    page.should_not have_content("Follow this user")
    page.should_not have_content("Unfollow this user")
  end
  
  scenario "Editing profile" do
    visit edit_profile_page
    fill_in("Name", :with => "Another Name")
    fill_in("Current password", :with => "123456")
    click_button("Update")
    page.should have_content("You updated your account successfully.")
  end
end
