require 'spec_helper'

describe GroupDocument do
  before(:each) do
    @group_document = Factory(:group_document)
  end

	it 'should delegate its name, description and file and file_url to its document' do
		parent = @group_document.document
		@group_document.name.should == parent.name
		@group_document.description.should == parent.description
		#@group_document.file.should == parent.file
		@group_document.file_url.should == parent.file_url
	end
	
	it "should accept a pending document, create an update of such and update its group's document count" do	
		count = @group_document.group.reload.documents_count
		
		@group_document.accept
		@group_document.pending.should be_false
		
		@group_document.targeted_updates.should_not be_blank
		@group_document.targeted_updates.first.creator.should == @group_document.group
		
		
		@group_document.group.reload.documents_count.should == count + 1
	end
	
	it "should create a user document referring its sender to the document" do
		@group_document.sender.has_document?(@group_document.document).should be_true
	end
	
	it "should create an update and update its group's document count after being created case the creator is also the group leader" do
		user = Factory(:user)
		group = Factory(:group, :leader => user)
		document = Factory(:group_document, :group => group, :sender => user)
		document.targeted_updates.should_not be_blank
		document.targeted_updates.first.creator.should == document.group
		group.reload.documents_count.should == 1
	end 
	
	it "should decrement a group's document count when deleted" do
		group = @group_document.group
		count = group.documents_count
		@group_document.destroy
		group.reload.documents_count.should == count - 1
	end

end

# == Schema Information
#
# Table name: group_documents
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  group_id        :integer(4)
#  document_id     :integer(4)
#  group_module_id :integer(4)
#  pending         :boolean(1)      default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

