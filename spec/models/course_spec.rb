require 'spec_helper'

describe Course do
	before :each do
		@course = Factory(:course)
	end
	
	it "should create an update right after being created itself" do
		@course.update_references.should_not be_blank
		@course.update_references.first.owner.should == @course.teacher
	end
	
	it "should return its name on #to_s" do
		@course.to_s.should == @course.name
	end
	
	it "should create a student" do
		student = @course.create_student(Factory(:user))
		@course.students.first.should == student
	end
	
	it "should remove a student" do
		user = Factory(:user)
		student = @course.create_student(user)
		@course.remove_student(user)
		@course.reload
		@course.students.should_not include(student)
	end
	
  describe "validations" do
  	it "should have a name" do
  		Course.new.should_not be_valid
  	end
  end
end
