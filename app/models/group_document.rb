# == Schema Information
# Schema version: 20110227225207
#
# Table name: group_documents
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  group_id        :integer(4)
#  document_id     :integer(4)
#  group_module_id :integer(4)
#  pending         :boolean(1)
#  created_at      :datetime
#  updated_at      :datetime
#

class GroupDocument < ActiveRecord::Base
	belongs_to :sender, :foreign_key => 'user_id', :class_name => "User"
	belongs_to :group
	belongs_to :document
	belongs_to :module, :foreign_key => 'group_module_id', :class_name => "GroupModule"
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
	
	scope :accepted, where(:pending => false)
	scope :pending, where(:pending => true)
	
	delegate :name, :description, :file, :file_url, :to => :document
	
	def accept
		self.update_attribute(:pending, false)
		self.group.updates.create!(:target => self)		
	end

end
