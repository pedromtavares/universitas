require File.dirname(__FILE__) + '/acceptance_helper'

feature "Teacher Navigation", %q{
  In order to teach a course
  as a teacher
  I want to be able to edit my course and manage its documents
} do

  background do
    logged_in_as "default"
    few_users_registered
  end
end
