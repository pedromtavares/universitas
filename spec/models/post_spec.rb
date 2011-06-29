require 'spec_helper'

describe Post do
  before(:each) do
    @post = Factory(:post)
  end

  it { should have_valid(:text).when('Test') }
	it { should_not have_valid(:text).when('a', nil, '')}

	
	it "should create an update on its group right after being created itself, unless it's the first post in its topic" do
		other = Factory(:post, :topic => @post.topic)
		target = @post.topic.forum.group.updates.first.target
		target.should_not == @post
		target.should == other
	end
end

# == Schema Information
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  topic_id   :integer(4)
#  user_id    :integer(4)
#  text       :text
#  ancestry   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

