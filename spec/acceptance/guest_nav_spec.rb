require File.dirname(__FILE__) + '/acceptance_helper'

feature "Guest Navigation", %q{
  In order to use the application
  as a guest user
  I want to be able to browse through user profiles, documents, groups and forums without being asked to log in.
} do

  background do
    few_users_registered
  end

  scenario "Visiting user index" do
    visit users_page
    page.should_not have_content("You need to sign in or sign up before continuing.")
  end

	scenario "Visiting user profiles" do
		visit other_user_profile
		page.should_not have_content("You need to sign in or sign up before continuing.")
		page.should_not have_content("Follow this user")
		page.should_not have_content("Unfollow this user")
	end
  
  scenario "Visiting groups index" do
		visit groups_path
    page.should_not have_content("You need to sign in or sign up before continuing.")
  end

	scenario "Trying to add a new group" do
		visit groups_path
		click_link_or_button("New Group")
		page.should have_content("You need to sign in or sign up before continuing.")
	end
  
  scenario "Visiting a group page" do
		visit group_page(other_group)
		page.should have_content("You must be a member of this group to share documents with it!")
		page.should_not have_content("You need to sign in or sign up before continuing.")
    page.should_not have_button("Join this group")
  end

	scenario "Visiting documents index" do
		visit documents_path
    page.should_not have_content("You need to sign in or sign up before continuing.")
  end

	scenario "Visiting the dashboard or trying to get to the group creation form will screw you up" do
		visit dashboard
		page.should have_content("You need to sign in or sign up before continuing.")
		visit group_creation_page
		page.should have_content("You need to sign in or sign up before continuing.")
	end
	
	scenario "Browsing through forums" do
		visit group_path(other_group)
		click_link_or_button("Forums")
		page.should_not have_content("You need to sign in or sign up before continuing.")
		generate_posts_for(other_forum)
		visit group_forum_topic_path(other_forum.group, other_forum, other_forum.topics.first)
		page.should_not have_content("You need to sign in or sign up before continuing.")
		fill_in("text", :with => "testing")
		click_link_or_button("Post")
		page.should have_content("You need to sign in or sign up before continuing.")
	end
end
