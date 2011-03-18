class GroupMember < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
	has_many :updates, :as => :target, :dependent => :destroy

	after_create :status_update
	
  delegate :name, :email, :to => :user

	private
	
	def status_update
		self.user.updates.create!(:target => self)
	end
end
