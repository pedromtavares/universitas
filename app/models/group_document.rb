class GroupDocument < ActiveRecord::Base
	belongs_to :sender, :foreign_key => 'user_id', :class_name => "User"
	belongs_to :group
	belongs_to :document
	belongs_to :group_module
	
	delegate :name, :description, :file, :to => :document
end