Feature: Manage app_should_boots
  In order to see what my app is about
  a user
  wants to be able to land on a home page
  
  Scenario: Visiting the site for the first time
    Given I am on the home page
    Then I should see "Welcome aboard" within "h1"