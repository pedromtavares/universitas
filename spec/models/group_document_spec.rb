require 'spec_helper'

describe GroupDocument do
  before(:each) do
    @group_document = Factory(:group_document)
  end

	it 'should delegate its name, description and file and file_url to its document' do
		parent = @group_document.document
		@group_document.name.should == parent.name
		@group_document.description.should == parent.description
		@group_document.file.should == parent.file
		@group_document.file_url.should == parent.file_url
	end
	
	it "should create an update right after being accepted" do
		@group_document.accept
		@group_document.targeted_updates.should_not be_blank
		@group_document.targeted_updates.first.creator.should == @group_document.group
	end

end
