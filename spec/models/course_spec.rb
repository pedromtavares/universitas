require 'spec_helper'

describe Course do
	before :each do
		@course = Factory(:course)
	end
	
	it "should return its name on #to_s" do
		@course.to_s.should == @course.name
	end
	
  describe "validations" do
  	it "should have a name" do
  		Course.new.should_not be_valid
  	end
  end
end
