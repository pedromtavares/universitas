# == Schema Information
# Schema version: 20110227225207
#
# Table name: groups
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  user_id     :integer(4)
#  cached_slug :string(255)
#  image       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Group < ActiveRecord::Base
  has_many :members, :class_name => 'GroupMember'
	has_many :group_documents
	has_many :documents, :through => :group_documents
	has_many :modules, :class_name => 'GroupModule'
	has_many :updates, :as => :creator, :dependent => :destroy
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
  belongs_to :leader, :class_name => 'User', :foreign_key => 'user_id'
	attr_accessible :leader, :name, :image, :description
	
  has_friendly_id :name, :use_slug => true
	mount_uploader :image, ImageUploader

	after_create :status_update, :create_first_member

	validates :name, :presence => true
	validates :image, :length => {:maximum => 10000000, :message => I18n.t('custom_messages.file_validation')}
  
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
	
	def update_status(msg)
		self.update_attribute(:status, msg)
		self.updates.create!(:target => self, :custom_message => msg)
	end

	private
	
	def status_update
		self.leader.updates.create(:target => self)
	end
	
	def create_first_member
		self.create_member(self.leader)
	end
end
