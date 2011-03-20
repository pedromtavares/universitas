require 'spec_helper'

describe Document do
  before(:each) do
    @document = Factory(:document)
  end

	it "should return its name on #to_s" do
		@document.to_s.should == @document.name
	end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:document, :name => nil).should_not be_valid
  	end

		it "should have a file" do
			Factory.build(:document, :file => nil).should_not be_valid
		end
  end
end
