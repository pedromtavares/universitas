require 'spec_helper'

describe UserDocument do
  before(:each) do
    @user_document = Factory(:user_document)
  end

	it 'should delegate its name, description and file and file_url to its document' do
		parent = @user_document.document
		@user_document.name.should == parent.name
		@user_document.description.should == parent.description
		@user_document.file.should == parent.file
		@user_document.file_url.should == parent.file_url
	end
	
	it "should create an update right after being created" do
		@user_document.targeted_updates.should_not be_blank
		@user_document.targeted_updates.first.creator.should == @user_document.user
	end

end
