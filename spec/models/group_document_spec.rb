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
	
	it "should accept a pending document and create an update of such" do
		@group_document.accept
		@group_document.pending.should be_false
		@group_document.targeted_updates.should_not be_blank
		@group_document.targeted_updates.first.creator.should == @group_document.group
	end
	
	it "should create a user document referring its sender to the document" do
		@group_document.sender.has_document?(@group_document.document).should be_true
	end

end
