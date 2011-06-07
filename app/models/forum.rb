# == Schema Information
# Schema version: 20110227225207
#
# Table name: forums
#
#  id           :integer(4)      not null, primary key
#  group_id     :integer(4)
#  title        :string(255)
#  description  :text
#  topics_count :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

class Forum < ActiveRecord::Base
	belongs_to :group
	has_many :topics, :dependent => :destroy
	has_many :posts, :through => :topics
	validates :title, :presence => true, :length => 2..200
	validates :description, :length => {:maximum => 400}
	
	def to_s
		self.title
	end
	
	def last_post
		self.posts.order('created_at desc').first
	end
end
