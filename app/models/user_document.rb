class UserDocument < ActiveRecord::Base
	belongs_to :user
	belongs_to :document
	has_many :updates, :as => :target, :dependent => :destroy

	after_create :status_update
	
	delegate :name, :description, :file, :to => :document
	
	private
	
	def status_update
		self.user.updates.create!(:target => self)
	end
end