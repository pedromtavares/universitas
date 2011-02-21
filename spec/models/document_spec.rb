require 'spec_helper'

describe Document do
  before(:each) do
    @document = Factory(:document)
  end

	it "should create an update right after being created itself" do
		@document.update_references.should_not be_blank
		@document.update_references.first.owner.should == @document.course
	end

	it "should return its name on #to_s" do
		@document.to_s.should == @document.name
	end
end
