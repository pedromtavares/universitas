require 'spec_helper'

describe Document do
  before(:each) do
    @document = Factory(:document)
  end

	it "should create an update right after being created itself" do
		@document.targeted_updates.should_not be_blank
		@document.targeted_updates.first.creator.should == @document.user
	end

	it "should return its name on #to_s" do
		@document.to_s.should == @document.name
	end
end
