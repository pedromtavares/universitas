require File.dirname(__FILE__) + '/acceptance_helper'

feature "Signup", %q{
  In order to be able to login and use the application
  As a non-registered user
  I want to be able to signup
} do

  scenario "Signing up with valid data" do
    visit signup_page
    fill_in("Login", :with => "test")
    fill_in("Name", :with => "Test")
    fill_in("E-mail", :with => "test@test.com")
    fill_in("Password", :with => "123456")
    fill_in("Password confirmation", :with => "123456")
    click_button("Sign Up")
    page.should have_content("You have signed up successfully.")
    current_path.should == homepage
  end
  
  scenario "Signing up with invalid data" do
    visit signup_page
    fill_in("Login", :with => "tes")
    fill_in("Name", :with => "Test")
    fill_in("E-mail", :with => "test@test.com")
    fill_in("Password", :with => "123456")
    fill_in("Password confirmation", :with => "123456")
    click_button("Sign Up")
    page.should have_content("is too short (minimum is 4 characters)")
    current_path.should == users_path
  end
end