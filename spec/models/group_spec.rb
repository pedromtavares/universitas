require 'spec_helper'

describe Group do
	before :each do
		@group = Factory(:group)
	end
	
	it "should create an update right after being created itself" do
		@group.targeted_updates.should_not be_blank
		@group.targeted_updates.first.creator.should == @group.leader
	end
	
	it "should return its name on #to_s" do
		@group.to_s.should == @group.name
	end
	
	it "should create a member" do
		member = @group.create_member(Factory(:user))
		@group.members.should include(member)
	end
	
	it "should remove a member" do
		user = Factory(:user)
		member = @group.create_member(user)
		@group.remove_member(user)
		@group.reload
		@group.members.should_not include(member)
	end
	
	it 'should update its status' do
    @group.update_status("Hello")
    @group.status.should == "Hello"
  end

	it 'should have a timeline with its updates only' do
		@group.update_status("Hello")
		@group.timeline == @group.updates.to_a
	end
	
	it 'should be promoted by a member' do
		user = Factory(:user)
		member = @group.create_member(user)
		@group.promote("testing", user)
		user.updates.should include @group.targeted_updates.last
	end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:group, :name => nil).should_not be_valid
  	end
  end
end
