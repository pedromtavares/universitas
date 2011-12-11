# == Schema Information
# Schema version: 20110227225207
#
# Table name: updates
#
#  id             :integer(4)      not null, primary key
#  creator_id     :integer(4)
#  creator_type   :string(255)
#  target_id      :integer(4)
#  target_type    :string(255)
#  custom_message :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#

class Update < ActiveRecord::Base
	belongs_to :creator, :polymorphic => true
  belongs_to :target, :polymorphic => true  

	# generates from_user?, from_group?, etc...
	[User, Group].each do |klass|
		class_eval %Q!
			def from_#{klass.to_s.underscore}?
				self.creator.class.to_s == '#{klass.to_s}'
			end
		!
	end
	
	# generates to_user?, to_group_document?, etc...
	[User, Group, UserDocument, GroupDocument, GroupMember, Post, Topic, Comment].each do |klass|
		class_eval %Q!
			def to_#{klass.to_s.underscore}?
				self.target.class.to_s == '#{klass.to_s}'
			end
		!
	end
	
	def to_forum?
		self.to_post? || self.to_topic?
	end
	
end
