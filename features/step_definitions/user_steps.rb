def first_user
  @first ||= User.first
end

def last_user
  @last ||= User.last
end

Given /^there are some users registered$/ do
  @users = []
  20.times do
    @users << Factory(:user)
  end
end

Then /^I should see the first page of users$/ do
  9.times do |n|
    Then "I should see \"#{@users[n].name}\""
  end
end

Then /^I should not see the second page of users$/ do
  9.times do |n|
    Then "I should not see \"#{@users[n+10].name}\""
  end
end


Given /^I already follow the last user$/ do
  first_user.follow!(last_user)
end

Given /^I follow a few users$/ do
  @users.each do |user|
    first_user.follow!(user)
  end
end

Given /^I have a few followers$/ do
  @users.each do |user|
    user.follow!(first_user)
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

