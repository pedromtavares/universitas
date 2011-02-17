class Student < ActiveRecord::Base
  belongs_to :course
  belongs_to :user
	has_many :updates, :as => :reference, :dependent => :destroy

	after_create :status_update
	
  delegate :name, :email, :to => :user

	private
	
	def status_update
		self.user.updates.create!(:reference => self)
	end
end
