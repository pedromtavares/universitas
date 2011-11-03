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
#  location             :string(255)
#  website              :string(255)
#  twitter              :string(255)
#  facebook             :string(255)
#  image                :string(255)
#  description          :text
#  show_email           :boolean(1)      default(TRUE)
#  email                :string(255)     default(""), not null
#  encrypted_password   :string(128)     default(""), not null
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
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable

  validates :login, :presence => true, :uniqueness => true, :length => { :minimum => 4, :maximum => 20 }, :exclusion => {:in => Rails.application.routes.routes.map{|r| r.path.split('/').third.try(:gsub, /\(.*\)/, '')}.uniq}
  validates :name, :presence => true, :length => { :minimum => 4, :maximum => 50 }
	validates :email, :presence => true, :allow_blank => true, :format => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i, :if => :email_required?
	validates :email, :uniqueness => true, :allow_blank => true
	validates :password, :presence => true, :length => 6..20, :if => :password_required?
	validates :password, :confirmation => true
	
	validates_length_of :location, :website, :twitter, :facebook, :maximum => 200
	validates_length_of :description, :maximum => 500

  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me, :image, :location, :description, :twitter, :facebook, :show_email, :website, :remote_image_url, :remove_image
  has_friendly_id :login, :use_slug => true
	mount_uploader :image, ImageUploader
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :dependent => :destroy, :class_name => 'Relationship'
  has_many :followers, :through => :reverse_relationships
  has_many :updates, :as => :creator, :dependent => :destroy
	has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
	has_many :group_members, :dependent => :destroy
  has_many :groups, :through => :group_members, :dependent => :destroy
  has_many :groups_leadered, :class_name => 'Group'
	has_many :user_documents, :dependent => :destroy
	has_many :documents, :through => :user_documents
	has_many :group_documents
	has_many :uploaded_documents, :class_name => 'Document'
	has_many :authentications, :dependent => :destroy
	has_many :posts, :dependent => :destroy
  
  def to_s
    self.login
  end

	def self.search(search)
		self.where("name like ? or login like ?", "%#{search}%", "%#{search}%")
	end
  
  def update_status(msg)
    return if msg.blank? || msg == self.status
    self.update_attribute :status, msg
    self.updates.create!(:target => self, :custom_message => msg)    
  end
  
  def feed(last = Time.now + 1.second)
		Update.where("((creator_id IN (?) or creator_id = ?) and creator_type='User') or (creator_id in (?) and creator_type='Group')", self.following, self.id, self.groups).where('created_at < ?', last).limit(20).order('created_at desc')
  end

	def timeline(last = Time.now + 1.second)
    Update.where("creator_id = ? and creator_type='User'", self.id).where('created_at < ?', last).limit(20).order('created_at desc')
	end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id) unless followed == self || self.following?(followed)
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
	
	def has_document?(document_id)
		self.documents.exists?(document_id)
	end
	
	def uploaded_document?(document_id)
		self.uploaded_documents.exists?(document_id)
	end
	
	def add_document(document_id)
		document = Document.find(document_id)
		self.user_documents.create(:document => document) unless self.has_document?(document)
	end
	
	def remove_document(document_id)
		# the reason this find is necessary is because we need to use the integer id on the find_by_document_id(), not the named slug
		document = Document.find(document_id)
		self.user_documents.find_by_document_id(document).destroy if self.has_document?(document)
	end
	
	def has_provider?(provider)
		self.authentications.find_by_provider(provider)
	end
	
	def has_all_providers
		self.authentications.count == Authentication::PROVIDERS.size
	end
	
	def has_no_password
		self.encrypted_password.blank?
	end
	
	def password_required?
	  self.authentications.blank? && (!self.persisted? || !self.password.nil? || !self.password_confirmation.nil?)
	end
	
	def email_required?
		self.authentications.blank? || self.persisted?
	end
	
	def add_service_info(omniauth)
		twitter = omniauth['user_info']['urls']['Twitter']
		facebook = omniauth['user_info']['urls']['Facebook']
		image = omniauth['user_info']['image']
		email = omniauth['user_info']['email']
		location = omniauth['user_info']['location']
		description = omniauth['user_info']['description']
		website = omniauth['user_info']['urls']['Website']
		
		self.twitter = twitter unless twitter.blank?
		self.facebook = facebook unless facebook.blank?
		self.remote_image_url = image unless image.blank? || self.image?
		self.email = email unless email.blank? || self.email?
		self.location = location unless location.blank? || self.location?
		self.description = description unless description.blank? || self.description?
		self.website = website unless website.blank? || self.website?
		self.save
	end
	
	def self.create_from_omniauth(omniauth)
		name = omniauth['user_info']['name']
		login = omniauth['user_info']['nickname'].blank? ? name.parameterize : omniauth['user_info']['nickname']
		email = omniauth['user_info']['email'] || ""
		location = omniauth['user_info']['location']
		image = omniauth['user_info']['image']
		description = omniauth['user_info']['description']
		twitter = omniauth['user_info']['urls']['Twitter']
		facebook = omniauth['user_info']['urls']['Facebook']
		website = omniauth['user_info']['urls']['Website']
    user = User.new(:name => name, :login => login, :email => email, :remote_image_url => image, :location => location, :twitter => twitter, :facebook => facebook, :description => description, :website => website)
		user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
		user
	end
	
	# devise override
	def update_with_password(params={}) 
	  if self.has_no_password || !(params[:email] || params[:login] || params[:name] || params[:password])
			update_attributes(params) 
		else
			super
		end
	end
  
end
