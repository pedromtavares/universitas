require 'spec_helper'

describe Forum do
  before(:each) do
    @forum = Factory(:forum)
  end

  it { should have_valid(:title).when('Test') }
	it { should have_valid(:description).when('Testing') }
	it { should_not have_valid(:title).when('T', 'T'*201, nil, '')}
	it { should_not have_valid(:description).when('T'*401)}
	
	it 'should print its title by default' do
		@forum.to_s.should == @forum.title
	end
	
	it 'should have a last post as its latest one' do
		topic = Factory(:topic, :forum => @forum)
		@forum.last_post.should == topic.posts.first
	end

end
