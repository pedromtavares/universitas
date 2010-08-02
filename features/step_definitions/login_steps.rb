Given /^I am logged in as "([^\"]*)" with the "([^\"]*)" password$/ do |login, password|
  user = User.find_by_login( login )
  if user
    user.password = password
    user.password_confirmation = password
    user.save!
  else
    Factory(:user, :login => 'default', :password => password, :name => 'Default')
  end
  Given 'I am on the login page'
  When "I fill in \"Login\" with \"#{login}\""
  When "I fill in \"Password\" with \"#{password}\""
  When 'I press "Login"'
end