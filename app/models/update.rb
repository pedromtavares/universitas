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

	def from_user?
		self.creator.class.to_s == 'User'
	end
	
	def from_group?
		self.creator.class.to_s == 'Group'
	end
end
