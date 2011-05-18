require File.dirname(__FILE__) + '/acceptance_helper'

feature "User dashboard", %q{
  In order to browse through my dashboard
  as a registered user
  I want to be able to see my status feed and update my status
} do
  
  background do
    logged_in_as("default")
    few_users_registered
  end

  scenario "Status feed" do
    user_following_other_users
    visit dashboard
    primary_user.following.each do |user|
      page.should have_content("Hello from #{user.name}")
    end
  end
  
  scenario "Updating status" do
    user_has_some_followers
    visit dashboard
    fill_in("status", :with => "Testing")
    click_button("Update")
    page.should have_content("Testing")
    primary_user.followers.each do |user|
      click_link_or_button "Sign out"
      logged_in_as(user.login)
      visit dashboard
      page.should have_content("Testing")
    end
  end
end