class GroupModule < ActiveRecord::Base
	belongs_to :group
	has_many :group_documents
end