require 'spec_helper'

describe GroupMember do
	before :each do
		@group = Factory(:group)
		@module = Factory(:group_module, :group => @group)
	end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:group_module, :name => nil).should_not be_valid
  	end
  end
	
	it "should increment it's group's counter cache" do
		count = @group.reload.modules_count
		Factory(:group_module, :group => @group)
		@group.reload.modules_count.should == count + 1
	end
end
