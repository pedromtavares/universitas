require 'spec_helper'

describe Update do
  before(:each) do
    @user = Factory(:user)
  end
  it 'should create a new status update' do
    update = Update.new_status(@user, "Hello")
    Update.first.content.should == " updated status to: \"Hello\""
    Update.first.user.should == @user
  end
end
