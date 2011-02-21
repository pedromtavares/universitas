require File.dirname(__FILE__) + '/acceptance_helper'

feature "Student Navigation", %q{
  In order to learn from a course
  as a student
  I want to be able to browse through said course and its documents
} do

  background do
    logged_in_as "default"
    few_users_registered
  end
end
