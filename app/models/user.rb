# == Schema Information
# Schema version: 20110227225207
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  login                :string(255)     not null
#  name                 :string(255)     not null
#  status               :string(255)
#  cached_slug          :string(255)
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
#  password_salt        :string(255)     default(""), not null
#  reset_password_token :string(255)
#  remember_token       :string(255)
#  remember_created_at  :datetime
#  sign_in_count        :integer(4)      default(0)
#  current_sign_in_at   :datetime
#  last_sign_in_at      :datetime
#  current_sign_in_ip   :string(255)
#  last_sign_in_ip      :string(255)
#  created_at           :datetime
#  updated_at           :datetime
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  validates :login, :presence => true, :uniqueness => true, :length => { :minimum => 4, :maximum => 20 }
  validates :name, :presence => true, :length => { :minimum => 4, :maximum => 50 }
  
  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me
  has_friendly_id :login, :use_slug => true
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :dependent => :destroy, :class_name => 'Relationship'
  has_many :followers, :through => :reverse_relationships
  has_many :updates, :as => :creator, :dependent => :destroy
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
	has_many :group_members, :dependent => :destroy
  has_many :groups, :through => :group_members, :dependent => :destroy
  has_many :groups_leadered, :class_name => 'Group'
	has_many :user_documents
	has_many :documents, :through => :user_documents
	has_many :group_documents
	has_many :uploaded_documents, :class_name => 'Document'
  
  def to_s
    self.login
  end

	def self.search(search)
		self.where("name like ? or login like ?", "%#{search}%", "%#{search}%")
	end
  
  def update_status(msg)
    self.update_attribute :status, msg
    self.updates.create!(:target => self, :custom_message => msg)    
  end
  
  def feed    
    Update.where("((creator_id IN (?) or creator_id = ?) and creator_type='User') or (creator_id in (?) and creator_type='Group')", self.following, self.id, self.groups + self.groups_leadered).order('created_at desc')
  end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id) unless followed == self
  end
  
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
  def member_of?(group)
    self.groups.exists?(group)
  end
  
  def leader_of?(group)
    self.groups_leadered.exists?(group)
  end

	def has_document?(document)
		self.documents.exists?(document)
	end
  
end
