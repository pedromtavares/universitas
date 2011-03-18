class GroupModule < ActiveRecord::Base
	belongs_to :group
	has_many :documents, :class_name => 'GroupDocument'
end