require File.dirname(__FILE__) + '/acceptance_helper'

feature "Courses Management", %q{
	In order to enter, leave and manage courses
  as a registered user
	I want to be able to create and edit courses
		And I want to know who else entered that course
		And I want my profile to update accordingly to my course actions (enter/create)
} do

  background do
    logged_in_as("default")
    few_users_registered
  end
	
	scenario "Creating a new course" do
		visit courses_page
		click_link_or_button "New Course"
		fill_in("Name", :with => "My Course")
		click_button "Submit"
		page.should have_content("Course was successfully created.")
		page.should have_content("This course has no students!")
		page.should have_content("Default User")
		page.should_not have_content("Enter this course")
		page.should_not have_content("Leave this course")
		visit dashboard
		page.should have_content("created a course called ")
	end
	
	scenario "Editing an existing course" do
		visit course_page(default_course)
		click_link_or_button("Edit")
		fill_in("Description", :with => "Dis iz Spartaaaa!")
		click_button "Submit"
		page.should have_content("Course was successfully updated.")
	end
	
	scenario "Entering a course" do
		visit course_page(other_course)
		click_link_or_button("Enter this course")
		page.should have_content("Default User")
	 	page.should have_button("Leave this course")
		visit dashboard
		page.should have_content("entered a course called ")
	end
	
	scenario "Leaving a course" do
		visit course_page(other_course)
		click_link_or_button("Enter this course")
		click_link_or_button("Leave this course")
		page.should have_content("You have left the course")
		current_path.should == courses_page
		visit course_page(other_course)
		page.should_not have_content("Default User") #he should no longer be a student of that course
		visit dashboard
		within("#updates") do
			page.should_not have_content("Default User") #the update should be removed as well
		end
	end
end
