require File.dirname(__FILE__) + '/acceptance_helper'

feature "Groups Management", %q{
	In order to enter, leave and manage groups
  as a registered user
	I want to be able to create and edit groups
		And I want to know who else joined that group
		And I want my profile to update accordingly to my group actions (enter/create)
} do

  background do
    logged_in_as("default")
    few_users_registered
  end
	
	scenario "Creating a new group" do
		visit groups_page
		click_link_or_button "New Group"
		fill_in("Name", :with => "My Group")
		click_button "Submit"
		page.should have_content("Group was successfully created.")
		page.should have_content("This group has no students!")
		page.should have_content("Default User")
		page.should_not have_content("Join this group")
		page.should_not have_content("Leave this group")
		visit dashboard
		page.should have_content("created a group called ")
	end
	
	scenario "Editing an existing group" do
		visit group_page(default_group)
		click_link_or_button("Edit")
		fill_in("Description", :with => "Dis iz Spartaaaa!")
		click_button "Submit"
		page.should have_content("Group was successfully updated.")
	end
	
	scenario "Joining a group" do
		visit group_page(other_group)
		click_link_or_button("Join this group")
		page.should have_content("Default User")
	 	page.should have_button("Leave this group")
		visit dashboard
		page.should have_content("joined a group called ")
	end
	
	scenario "Leaving a group" do
		visit group_page(other_group)
		click_link_or_button("Join this group")
		click_link_or_button("Leave this group")
		page.should have_content("You have left the group")
		current_path.should == groups_page
		visit group_page(other_group)
		page.should_not have_content("Default User") #he should no longer be a student of that group
		visit dashboard
		within("#updates") do
			page.should_not have_content("Default User") #the update should be removed as well
		end
	end
end
