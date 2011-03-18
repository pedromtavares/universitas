require File.dirname(__FILE__) + '/acceptance_helper'

feature "Group Member Navigation", %q{
  In order to navigate a group
  as a group member
  I want to be able to browse through said group, download and share documents
} do

  background do
    logged_in_as "default"
    few_users_registered
  end
end
