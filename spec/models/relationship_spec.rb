require 'spec_helper'

describe Relationship do

  before(:each) do
    @follower = Factory(:user)
    @followed = Factory(:user)
    @relationship = @follower.relationships.build(:followed_id => @followed.id)
  end

  it "should create a new instance given valid attributes" do
    @relationship.save!
  end
  
  describe "validations" do
    it "should require a follower_id" do
      @relationship.follower_id = nil
      @relationship.should_not be_valid
    end
    it "should require a followed_id" do
      @relationship.followed_id = nil
      @relationship.should_not be_valid
    end
  end
  
  describe "follow methods" do
    before(:each) do
      @relationship.save
    end
    it "should have the right follower" do
      @relationship.follower.should == @follower
    end
    it "should have the right followed user" do
      @relationship.followed.should == @followed
    end
  end
end
