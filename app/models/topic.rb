# == Schema Information
# Schema version: 20110227225207
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

class Topic < ActiveRecord::Base
	belongs_to :forum, :counter_cache => :topics_count
	has_many :posts, :dependent => :destroy
	validates :title, :presence => true, :length => 2..200
	delegate :text, :author, :to => :first_post, :allow_nil => true
	
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
	
	after_create :create_update
	
	def to_s
		self.title
	end
	
	def first_post
		self.posts.order('created_at asc').first
	end
	
	def last_post
		self.posts.order('created_at desc').first
	end
	
	private
	
	def create_update
		self.forum.group.updates.create(:target => self)
	end
end
