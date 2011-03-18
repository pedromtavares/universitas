class Group < ActiveRecord::Base
  has_many :members, :class_name => 'GroupMember'
	has_many :documents, :class_name => 'GroupDocument'
	has_many :modules, :class_name => 'GroupModule'
	has_many :updates, :as => :creator, :dependent => :destroy
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
  belongs_to :leader, :class_name => 'User', :foreign_key => 'user_id'
  has_friendly_id :name, :use_slug => true
	after_create :status_update

	validates :name, :presence => true
  
  def to_s
    self.name
  end

	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end

	def create_member(user)
		self.members.create(:user => user)
	end
	
	def remove_member(user)
		self.members.where(:user_id => user).first.destroy
	end

	private
	
	def status_update
		self.leader.updates.create(:target => self)
	end
end
