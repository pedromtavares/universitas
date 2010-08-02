Feature: Signup

  In order to be able to login and use the application
  As a non-registered user
  I want to be able to signup      
      
  Scenario: Signing up with valid data
  	Given I am on the signup page
  		And I fill in "Login" with "test"
  		And I fill in "Name" with "Test"
  		And I fill in "Email" with "test@test.com"
  		And I fill in "Password" with "123456"
  		And I fill in "Password confirmation" with "123456"
  	When I press "Signup"
  		Then I should see "You have signed up successfully."
  		And I should be on the homepage
  
  Scenario: Signing up with invalid data
   	Given I am on the signup page
  		And I fill in "Login" with "tes"
  		And I fill in "Name" with "Test"
  		And I fill in "Email" with "test@test.com"
  		And I fill in "Password" with "123456"
  		And I fill in "Password confirmation" with "3456"
  	When I press "Signup"
  		Then I should see "errors prohibited this user from being saved:"
  			And I should be on the users page
  
