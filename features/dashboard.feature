Feature: User dashboard
  In order to browse through my dashboard
  as a registered user
  I want to be able to see my status feed and update my status
  
  Background:
  	Given I am logged in as "default" with the "123456" password
  		And there are some users registered
  		
  Scenario: Status feed
  	Given I follow a few users
  	When I go to my dashboard
  	Then I should see all the status updates from the users I follow
  	
  Scenario: Updating status
  	Given I have a few followers
		And I am on my dashboard
		And I fill in "status" with "Testing"
	When I press "Update"
	Then I should see "Testing"
		And all my followers should see my status update to "Testing"
    
  
