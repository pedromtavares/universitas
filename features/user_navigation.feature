Feature: User navigation
  In order to use the application
  as a registered user
  I want to be able to browse through user profiles, follow and unfollow other users.
  
  Background:
  	Given I am logged in as "default" with the "123456" password
  		And there are some users registered
  
  Scenario: Listing users
	Given I am on the homepage 
	Then I should see the first page of users
	But I should not see the second page of users
	
  Scenario: Following users
  	Given I am on the last user's page
  	When I follow "Follow this user"
  	Then I should see "You are now following"	
  	
  Scenario: Unfollowing users
  	Given I already follow the last user
  		And I am on the last user's page
  	When I follow "Unfollow this user"
  	Then I should see "You have unfollowed"	
	
    
  
