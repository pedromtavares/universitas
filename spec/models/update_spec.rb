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
	
	it 'should check if it came from a user' do
		update = @user.updates.create!(:target =>@user)
		update.from_user?.should be_true
	end
	
	it 'should check if it came from a group' do
		update = @group.updates.create!(:target =>@group)
		update.from_group?.should be_true
	end
	
end

# == Schema Information
#
# Table name: updates
#
#  id             :integer(4)      not null, primary key
#  creator_id     :integer(4)
#  creator_type   :string(255)
#  target_id      :integer(4)
#  target_type    :string(255)
#  custom_message :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

