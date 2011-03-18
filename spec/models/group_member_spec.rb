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
	
	it "should delete updates associated with it when it is destroyed" do
		@member.destroy
		Update.where(:target_id => @member, :target_type => "GroupMember").should be_blank
	end
end
