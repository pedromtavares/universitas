require File.dirname(__FILE__) + '/acceptance_helper'

feature "Group Leader Navigation", %q{
  In order to lead a group
  as a leader
  I want to be able to edit my group and manage its documents
} do

  background do
    logged_in_as "default"
    few_users_registered
  end
end
