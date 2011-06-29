require 'spec_helper'

describe GroupMember do
	before :each do
		@user = Factory(:user)
		@group = Factory(:group)
		@member = Factory(:group_member, :user => @user, :group => @group)
	end
	
 	it "should delegate name and email to its user" do
		@member.name.should == @user.name
		@member.email.should == @user.email
 	end

	it "should create an update right after being created itself" do
		@member.updates.should_not be_blank
	end
	
	it "should increment it's group's counter cache" do
		count = @group.reload.members_count
		Factory(:group_member, :group => @group)
		@group.reload.members_count.should == count + 1
	end
end

# == Schema Information
#
# Table name: group_members
#
#  id         :integer(4)      not null, primary key
#  group_id   :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

