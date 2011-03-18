require File.dirname(__FILE__) + '/acceptance_helper'

feature "User Navigation", %q{
  In order to use the application
  as a registered user
  I want to be able to browse through user profiles, follow and unfollow other users.
} do

  background do
    logged_in_as "default"
    few_users_registered
  end
  scenario "Listing users" do
    visit users_page
    users[0..9].each do |user| #getting first page of users
      page.should have_content(user.name)
    end
    users[10..19].each do |user| #getting second page of users
      page.should_not have_content(user.name)
    end
  end
  
  scenario "Following users" do
    visit other_user_profile
    click_link_or_button "Follow this user"
    page.should have_content("You are now following")
  end
  
  scenario "Unfollowing users" do
    follow_other_user
    visit other_user_profile
    click_link_or_button "Unfollow this user"
    page.should have_content("You have unfollowed")
  end
end
