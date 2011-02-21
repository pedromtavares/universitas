require File.dirname(__FILE__) + '/acceptance_helper'

feature "Document Management", %q{
	In order to create, edit and download documents
  as a registered user
	I want to be able to create, edit and download documents
		And I want status updates on all course students and teacher regarding changes made
} do

  background do
    logged_in_as("default")
    few_users_registered
  end
end
