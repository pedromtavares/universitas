require 'spec_helper'

describe Student do
 	it "should delegate name and email to its user" do
		user = Factory(:user)
 		student = Student.create(:user => user, :course => Factory(:course))
		student.name.should == user.name
		student.email.should == user.email
 	end
end
