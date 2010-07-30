Feature: Users management
  In order to manage the users
  a user
  wants to be able to CRUD users
  
  Scenario: Listing users
    Given I am on the users page
    Then I should see "Listing users" within "h1"
  
  Scenario: Creating user
    Given I am on the users page
      And I follow "New User"
      And I fill in "user_name" with "Pedro"
      And I press "Create User"
    Then I should see "User was successfully created."
      And I should see "Pedro"
      
  Scenario: Showing user
    Given the following users exists:
      | name        |
      | Pedro       |
      And I go to the users page
      And I follow "Show"
    Then I should see "Pedro"
    
  Scenario: Updating user
    Given the following users exists:
      | name        |
      | Pedro       |
      And I go to the users page
      And I follow "Edit"
      And I fill in "user_name" with "Pedoca"
      And I press "Update User"
    Then I should see "Pedoca"
    
  Scenario: Destroying user
    Given the following users exists:
      | name        |
      | Pedro       |
      And I go to the users page
      And I follow "Destroy"
    Then I should not see "Pedro"
  
    
  
