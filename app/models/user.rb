class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  validates :login, :presence => true, :uniqueness => true
  validates :name, :presence => true
  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me
  has_friendly_id :login, :use_slug => true
  
  has_many :relationships, :foreign_key => "follower_id", :dependent => :destroy
  has_many :following, :through => :relationships, :source => :followed
  has_many :reverse_relationships, :foreign_key => "followed_id", :dependent => :destroy, :class_name => 'Relationship'
  has_many :followers, :through => :reverse_relationships
  
  def to_s
    self.login
  end
  
  def following?(followed)
    self.relationships.find_by_followed_id(followed)
  end

  def follow!(followed)
    self.relationships.create!(:followed_id => followed.id)
  end
  
  def unfollow!(followed)
    self.relationships.find_by_followed_id(followed).destroy
  end
  
end