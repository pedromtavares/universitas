require 'spec_helper'

describe User do

    before(:each) do
      @attr = { :name => "Default User", :email => "default@default.com", :login => 'default', :password => '123456', :password_confirmation => '123456' }
      @user = Factory(:user)
    end
    
    it "should create a new instance given valid attributes" do
      User.create!(@attr)
    end
    
    describe "name validations" do
      it "should require a name" do
        User.new(@attr.merge(:name => "")).should_not be_valid
      end
      it "should not accept large names nor small names" do
        User.new(@attr.merge(:name => "a" * 51)).should_not be_valid
        User.new(@attr.merge(:name => "a" * 3)).should_not be_valid
      end
    end
    
    describe "login validations" do
      it "should require a login" do
        User.new(@attr.merge(:login => "")).should_not be_valid
      end
      it "should not accept large logins nor small logins" do
        User.new(@attr.merge(:login => "a" * 21)).should_not be_valid
        User.new(@attr.merge(:login => "a" * 3)).should_not be_valid
      end
      it "should not accept 2 identical logins" do
        user = User.create!(@attr)
        User.new(@attr).should_not be_valid
      end
    end
    
    describe "e-mail validations" do
      it "should not accept invalid e-mail addresses" do
        User.new(@attr.merge(:email => "hahalol.com")).should_not be_valid
      end
    end
    
    describe "relationships" do
      before(:each) do
        @followed = Factory(:user)
      end
      it "should follow another user" do
        @user.follow!(@followed)
        @user.should be_following(@followed)
      end
      it "should include the followed user in the following array" do
        @user.follow!(@followed)
        @user.following.include?(@followed).should be_true
      end
      it "should include the follower in the followers array" do
        @user.follow!(@followed)
        @followed.followers.include?(@user).should be_true
      end
      it "should unfollow a user" do
        @user.follow!(@followed)
        @user.unfollow!(@followed)
        @user.should_not be_following(@followed)
      end
    end
    
    it 'should update its status' do
      @user.update_status("Hello")
      @user.status.should == "Hello"
    end
  
    it 'should return a feed with updates on the users it follows as well as its own' do
      followed = Factory(:user)
      followed.update_status("test")
      @user.update_status("hi")
      @user.follow!(followed)
      @user.feed.should == followed.updates + @user.updates
    end


  
end
