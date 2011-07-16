# == Schema Information
# Schema version: 20110227225207
#
# Table name: groups
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  description     :text
#  user_id         :integer(4)
#  cached_slug     :string(255)
#  image           :string(255)
#  status          :string(255)
#  modules_count   :integer(4)      default(0)
#  members_count   :integer(4)      default(0)
#  documents_count :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :datetime
#

class Group < ActiveRecord::Base
  has_many :members, :class_name => 'GroupMember', :dependent => :destroy
	has_many :users, :through => :members
	has_many :group_documents, :dependent => :destroy
	has_many :documents, :through => :group_documents
	has_many :modules, :class_name => 'GroupModule', :dependent => :destroy
	has_many :updates, :as => :creator, :dependent => :destroy
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
	has_many :forums, :dependent => :destroy
	has_many :topics, :through => :forums
  belongs_to :leader, :class_name => 'User', :foreign_key => 'user_id'
	
	attr_accessible :leader, :name, :image, :description, :modules_attributes
  has_friendly_id :name, :use_slug => true
	mount_uploader :image, ImageUploader
	after_create :create_update, :create_first_member, :create_first_forum
	
	accepts_nested_attributes_for :modules, :allow_destroy => true
	
	MAXIMUM_IMAGE_SIZE = 1000000
	MAXIMUM_IMAGE_SIZE_MB = MAXIMUM_IMAGE_SIZE/1000000

	validates :name, :presence => true, :uniqueness => true, :length => { :minimum => 4, :maximum => 100 }, :exclusion => {:in => Rails.application.routes.routes.map{|r| r.path.split('/').second.gsub(/\(.*\)/, '')}.uniq}
	validates :description, :length => {:maximum => 1000}
	validates :image, :length => {:maximum => MAXIMUM_IMAGE_SIZE, :message => I18n.t('custom_messages.image_validation', :size => MAXIMUM_IMAGE_SIZE_MB)}
  
  def to_s
    self.name
  end

	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end

	def create_member(user)
		self.members.create(:user => user) unless user.member_of?(self)
	end
	
	def remove_member(user)
		self.members.where(:user_id => user).first.destroy if user.member_of?(self) && !user.leader_of?(self)
	end
	
	def update_status(msg)
		self.update_attribute(:status, msg)
		self.updates.create!(:target => self, :custom_message => msg)
	end
	
	def modules_with_blank
		@blank ||= GroupModule.blank_module
		self.modules.include?(@blank) ? self.modules: self.modules.unshift(@blank)
	end
	
	def timeline(last = Time.now + 1.second)
		Update.where("creator_id = ? and creator_type='Group'", self.id).where('created_at < ?', last).limit(20).order('created_at desc')
	end
	
	def promote(msg, user)
		user.updates.create!(:target => self, :custom_message => msg)
	end
	
	def has_document?(document)
		self.documents.exists?(document)
	end
	
	def add_document(document, group_module, sender)
		document = document.is_a?(Document) ? document.id : document
		group_module = group_module.is_a?(GroupModule) ? group_module.id : group_module
		pending = !sender.leader_of?(self)
		unless self.has_document?(document)
			self.group_documents.create(:document_id => document, :pending => pending, :group_module_id => group_module, :sender => sender)
		end
	end
	
	def remove_document(document_id)
	  document = Document.find(document_id)
		self.group_documents.find_by_document_id(document).destroy if self.has_document?(document)
	end

	private
	
	def create_update
		self.leader.updates.create(:target => self)
	end
	
	def create_first_member
		self.create_member(self.leader)
	end
	
	def create_first_forum
		self.forums.create(:title => "Default")
	end
end
