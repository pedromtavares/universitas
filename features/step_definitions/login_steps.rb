Given /^I am logged in as "([^\"]*)" with the "([^\"]*)" password$/ do |login, password|
  user = User.find_by_login( login )
  Factory(:user, :login => 'default', :password => password, :name => 'Default') unless user
  Given 'I am on the login page'
  When "I fill in \"Login\" with \"#{login}\""
  When "I fill in \"Password\" with \"#{password}\""
  When 'I press "Login"'
end

Given /^I logout$/ do
  Given "I follow \"Logout\""
end