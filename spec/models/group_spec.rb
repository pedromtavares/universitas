require 'spec_helper'

describe Group do
	before :each do
		@group = Factory(:group)
	end
	
	describe "validations" do
  	it "should have a name" do
  		Factory.build(:group, :name => nil).should_not be_valid
  	end
  end
	
	it "should return its name on #to_s" do
		@group.to_s.should == @group.name
	end
	
	describe "members" do
		before(:each) do
			@user = Factory(:user)
			@member = Factory(:group_member, :user => @user, :group => @group)
		end
		it "should create a member" do
			member = @group.create_member(Factory(:user))
			@group.members.should include(member)
		end
		it "should remove a member" do
			@group.remove_member(@user)
			@group.reload
			@group.members.should_not include(@member)
		end
	end
	
	describe "updates & timeline" do
		it "should create an update right after being created itself" do
			@group.targeted_updates.should_not be_blank
			@group.targeted_updates.first.creator.should == @group.leader
		end
		it 'should have a timeline with its updates only' do
			@group.timeline.to_a == @group.updates.to_a
		end
	end
	
	it 'should update its status' do
		msg = "Hello"
    @group.update_status(msg)
    @group.status.should == msg
		@group.targeted_updates.last.custom_message.should == msg
  end
	
	it 'should be promoted by a member' do
		user = Factory(:user)
		member = @group.create_member(user)
		@group.promote("testing", user)
		user.updates.should include @group.targeted_updates.last
	end
	
	describe "documents" do
		before(:each) do
			@document = Factory(:document)
			@other_doc = Factory(:document)
			Factory(:group_document, :group => @group, :document => @document)
		end
		it 'should check if it has a certain document' do
			@group.has_document?(@document).should be_true
		end
		it 'should add a document' do
			user = Factory(:user)
			@group.add_document(@other_doc, nil, user)
			@group.documents.should include(@other_doc)
			@group.group_documents.last.pending.should be_true
		end
		it 'should remove a document' do
			@group.remove_document(@document)
			@group.documents.should_not include(@document)
		end
	end
end

# == Schema Information
#
# Table name: groups
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  description     :text
#  user_id         :integer(4)
#  cached_slug     :string(255)
#  image           :string(255)
#  status          :string(255)
#  modules_count   :integer(4)      default(0)
#  members_count   :integer(4)      default(0)
#  documents_count :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

