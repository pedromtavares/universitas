require 'spec_helper'

describe Student do
	before :each do
		@user = Factory(:user)
		@course = Factory(:course)
		@student = Factory(:student, :user => @user, :course => @course)
	end
	
 	it "should delegate name and email to its user" do
		@student.name.should == @user.name
		@student.email.should == @user.email
 	end

	it "should create an update right after being created itself" do
		@student.updates.should_not be_blank
	end
	
	it "should delete updates associated with it when it is destroyed" do
		@student.destroy
		Update.where(:reference_id => @student, :reference_type => "Student").should be_blank
	end
end
