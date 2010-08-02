Feature: User profile
  In order to access my profile information and modify it
  as a registered user
  I want to be able to see my followers as well as the users I follow
  	And I want to be able to edit my profile
  
  Background:
  	Given I am logged in as "default" with the "123456" password
  		And there are some users registered
  		
  Scenario: Profile information
  	Given I follow a few users
  		And I have a few followers
  	When I go to my profile page
  	Then I should see my e-mail address
  		And I should see my followers
  		And I should see the users I follow
  		And I should not see "Follow this user"
  		And I should not see "Unfollow this user"
  	
  Scenario: Editing profile
  	Given I am on my edit profile page
  		And I fill in "Name" with "Another Name"
  		And I fill in "Current Password" with "123456"
  	When I press "Update"
  	Then I should see "You updated your account successfully."
	
    
  
