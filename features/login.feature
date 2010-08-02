Feature: Login

  In order to be able to use the application
  As a user
  I want to be able to login

  Background:
    Given the following users exists:
      | name              	| login     				| password  | password_confirmation |
      | Default		 		| default					| 123456 	| 123456  	            |
      
      
  Scenario: Login required
  	Given I am on the homepage
  		Then I should see "You need to sign in or sign up before continuing."    

  Scenario: Login successfully
    Given I am on the login page
      And I fill in "Login" with "default"
      And I fill in "Password" with "123456"
     When I press "Login"
     Then I should see "Signed in successfully."
     	And I should be on the homepage
     	And I should see "Logged in as default"

  Scenario: Login failed
    Given I am on the login page
      And I fill in "Login" with "default"
      And I fill in "Password" with "654321"
     When I press "Login"
     Then I should see "Invalid login or password."
     	And I should be on the login page
     	
  Scenario: Logout
  	Given I am logged in as "default" with the "123456" password
  	When I follow "Logout"
  	Then I should be on the login page