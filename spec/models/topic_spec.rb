require 'spec_helper'

describe Topic do
  before(:each) do
    @topic = Factory(:topic)
  end

  it { should have_valid(:title).when('Test') }
	it { should_not have_valid(:title).when('T', 'T'*201, nil, '')}
	
	it 'should print its first post title by default' do
		@topic.to_s.should == @topic.title
	end
	
	it 'should have a first and last post' do
		post = Factory(:post, :topic => @topic)
		other = Factory(:post, :topic => @topic)
		
		@topic.first_post.should == post
		@topic.last_post.should == other
		@topic.first_post.should_not == other
		@topic.last_post.should_not == post
	end
	
	it 'should create a post' do
		post = @topic.create_post(:text => "hi", :author => Factory(:user))
		post.topic.should == @topic
	end
	
	it "should create an update on its group right after being created itself" do
		@topic.forum.group.updates.first.target.should == @topic
	end
	
	it "should delegate its text and author to its first post" do
		post = Factory(:post, :topic => @topic)
		@topic.text.should == post.text
		@topic.author.should == post.author
	end
	
end

# == Schema Information
#
# Table name: topics
#
#  id          :integer(4)      not null, primary key
#  forum_id    :integer(4)
#  posts_count :integer(4)      default(0)
#  title       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

