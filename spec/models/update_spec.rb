require 'spec_helper'

describe Update do
  before(:each) do
    @user = Factory(:user)
		@group = Factory(:group)
  end
  it 'should have a polymorphic target' do
    @user.updates.create!(:target => @user).target.should == @user
		@group.updates.create!(:target => @group).target.should == @group
  end  
	it 'should have a polymorphic creator' do
		@user.updates.create!(:target =>@user).creator.should == @user
		@group.updates.create!(:target => @user).creator.should == @group
	end
end
