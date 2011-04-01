# == Schema Information
# Schema version: 20110227225207
#
# Table name: user_documents
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  document_id :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class UserDocument < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"

	after_create :status_update
	
	delegate :name, :description, :file, :file_url, :to => :document
	
	private
	
	def status_update
		self.user.updates.create!(:target => self)
	end
end
