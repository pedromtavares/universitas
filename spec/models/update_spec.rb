require 'spec_helper'

describe Update do
  before(:each) do
    @user = Factory(:user)
  end
  it 'should have a polymorphic association' do
    @user.updates.create!(:reference => @user).reference.should == @user
  end  
end
