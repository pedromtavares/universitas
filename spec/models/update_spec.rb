require 'spec_helper'

describe Update do
  before(:each) do
    @user = Factory(:user)
		@course = Factory(:course)
  end
  it 'should have a polymorphic reference' do
    @user.updates.create!(:reference => @user).reference.should == @user
		@course.updates.create!(:reference => @course).reference.should == @course
  end  
	it 'should have a polymorphic owner' do
		@user.updates.create!(:reference =>@user).owner.should == @user
		@course.updates.create!(:reference => @user).owner.should == @course
	end
end
