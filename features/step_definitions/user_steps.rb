def first_user
  @first ||= User.first
end

def last_user
  @last ||= User.last
end

def users
  @users ||= []
end

Given /^there are some users registered$/ do
  20.times do
    new_user = Factory(:user)
    new_user.update_status("Hello from #{new_user.name}")
    users << new_user
  end
end

Given /^I already follow the last user$/ do
  first_user.follow!(last_user)
end

Given /^I follow a few users$/ do
  users.each do |user|
    first_user.follow!(user)
  end
end

Given /^I have a few followers$/ do
  users.each do |user|
    user.follow!(first_user)
  end
end

Then /^I should see the first page of users$/ do
  9.times do |n|
    Then "I should see \"#{users[n].name}\""
  end
end

Then /^I should not see the second page of users$/ do
  9.times do |n|
    Then "I should not see \"#{users[n+10].name}\""
  end
end


Then /^I should see my e\-mail address$/ do
  Then "I should see \"#{first_user.email}\""
end

Then /^I should see my followers$/ do
  first_user.followers.each do |user|
    Then "I should see \"#{user.name}\""
  end
end

Then /^I should see the users I follow$/ do
    first_user.following.each do |user|
    Then "I should see \"#{user.name}\""
  end
end

Then /^I should see all the status updates from the users I follow$/ do
  following = first_user.following
  following.each do |user|
    Then "I should see \"Hello from #{user.name}\""
  end
end

Then /^all my followers should see my status update to "([^"]*)"$/ do |message|
  followers = first_user.followers
  followers.each do |user|
    Given "I logout"
    Given "I am logged in as \"#{user.login}\" with the \"#{user.password}\" password"
    When "I go to my dashboard"
    Then "I should see \"#{message}\""
  end
end



