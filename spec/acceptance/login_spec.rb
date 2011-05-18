require File.dirname(__FILE__) + '/acceptance_helper'

feature "Login", %q{
  In order to be able to use the application
  As a user
  I want to be able to login
} do

  scenario "Login required" do
    visit dashboard
    page.should have_content("You need to sign in or sign up before continuing.")
  end
  
  scenario "Login sucessfully" do
    logged_in_as("default")
    page.should have_content("Signed in successfully.") and page.should have_content("Logged in as default")
    current_path.should == dashboard
  end
  
  scenario "Login failed" do
    visit login_page
    fill_in("Login", :with => "default")
    fill_in("Password", :with => "654321")
    click_button("Login")
    page.should have_content("Invalid login or password.")
    current_path.should == login_page
  end
  
  scenario "Logout" do
    logged_in_as("default")
    click_link_or_button("Sign out")
    current_path.should == homepage
  end
  
end
