require 'spec_helper'

describe User do

    before(:each) do
      @attr = { :name => "Default User", :email => "default@default.com", :login => 'default', :password => '123456', :password_confirmation => '123456' }
      @user = Factory(:user)
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
			it "should not validate if e-mail is not required" do
				user = User.new(@attr.merge(:email => ''))
				user.authentications << Factory.build(:authentication)
				user.should be_valid
			end
    end

		describe "password validations" do
			it "should not accept small passwords" do
				User.new(@attr.merge(:password => "1234", :password_confirmation => "1234")).should_not be_valid
			end
			it "should not validate if password is not required" do
				user = User.new(@attr.merge(:password => '', :password_confirmation => ''))
				user.authentications << Factory.build(:authentication)
				user.should be_valid
			end
		end
    
    describe "relationships" do
      before(:each) do
        @followed = Factory(:user)
				@user.follow!(@followed)
      end
      it "should follow another user" do    
        @user.should be_following(@followed)
      end
      it "should include the followed user in the following array" do
        @user.following.include?(@followed).should be_true
      end
      it "should include the follower in the followers array" do
        @followed.followers.include?(@user).should be_true
      end
      it "should unfollow a user" do
        @user.unfollow!(@followed)
        @user.should_not be_following(@followed)
      end
    end
    
    describe "updating status" do
			before(:each) do
				@user.update_status("Hello")
			end
    	it 'should update its status' do
	      @user.status.should == "Hello"
	    end
			it "should create an update when updating status" do
				@user.targeted_updates.should_not be_blank
				@user.targeted_updates.first.creator.should == @user
			end
    end

		describe "groups" do
			before(:each) do
				@group = Factory(:group)
			end
			it "should check if it's in a group" do
				@group.create_member(@user)
				@user.member_of?(@group).should be_true
			end
			it "should check if it's a group leader" do
				group = Factory(:group, :leader => @user)
				@user.leader_of?(group).should be_true
				@user.member_of?(group).should be_true
			end
		end
		
		describe "documents" do
			before(:each) do
				@document = Factory(:document, :uploader => @user)
				@other_user = Factory(:user)
				Factory(:user_document, :user => @other_user, :document => @document)
			end
			it 'should check if it has a certain document' do
				@user.has_document?(@document).should be_false
				@other_user.has_document?(@document).should be_true
			end
			it 'should check if it uploaded a document' do
				@user.uploaded_document?(@document).should be_true
				@other_user.uploaded_document?(@document).should be_false
			end
			it 'should add a document' do
				@user.add_document(@document)
				@user.documents.should include(@document)
			end
			it 'should remove a document' do
				@other_user.remove_document(@document)
				@other_user.documents.should_not include(@document)
			end
		end
		
		describe "feeds" do
			before(:each) do
				@followed = Factory(:user)
				@group = Factory(:group)
	      @followed.update_status("test")
				@group.update_status("group!")
				@group.create_member(@user)
	      @user.update_status("hi")
	      @user.follow!(@followed)
			end
			it 'should return a feed with updates on the users it follows as well as its own' do
	      @user.feed.to_a.should == @followed.updates + @group.updates + @user.updates
	    end

			it 'should return a timeline with its updates only' do
	      @user.timeline.to_a.should == @user.updates.to_a
			end
		end
		
		
		describe "authentications" do
			it 'should check if it has a certain provider' do
				@authentication = Factory(:authentication, :provider => 'twitter', :user => @user)
				@user.has_provider?('twitter').should be_true
			end
			it 'should check if it has all providers' do
				Authentication::PROVIDERS.each do |provider|
					Factory(:authentication, :provider => provider, :user => @user) unless @user.has_provider?(provider)
				end
				@user.has_all_providers.should be_true
			end
		end
		
		describe "omniauth" do
			before(:each) do
				@omniauth = {'provider'=> 'twitter', 'uid' => '12345', 'user_info' => {'name' => 'test', 'nickname' => 'test', 'email' => 'test@email.com', 'image' => '', 'urls' => {'Twitter' => 'twitter.com/test'}}}
			end
			it 'should create a user from omniauth params' do
				user = User.create_from_omniauth(@omniauth)
				auth = user.authentications.first
				user.name.should == 'test'
				user.login.should == 'test'
				auth.uid.should == '12345'
				auth.provider.should == 'twitter'		
			end
			
			it 'should add service info to an already existing user' do
				@user.add_service_info(@omniauth)
				@user.email.should_not == @omniauth['user_info']['email'] #user already has email
				@user.twitter.should == @omniauth['user_info']['urls']['Twitter']
				@user.image.should be_blank
				
			end
		
		end
		
end
