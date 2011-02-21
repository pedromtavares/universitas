# == Schema Information
# Schema version: 20100801203120
#
# Table name: users
#
#  id                   :integer(4)      not null, primary key
#  login                :string(255)     not null
#  name                 :string(255)     not null
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
  has_many :updates, :as => :owner, :dependent => :destroy
	has_many :update_references, :as => :reference, :dependent => :destroy, :class_name => "Update"
  has_many :students, :dependent => :destroy
  has_many :courses, :through => :students
  has_many :courses_teached, :class_name => 'Course', :foreign_key => "teacher_id"
  
  def to_s
    self.login
  end
  
  def update_status(msg)
    self.update_attribute :status, msg
    self.updates.create!(:reference => self)    
  end
  
  def feed    
    Update.where("((owner_id IN (?) or owner_id = ?) and owner_type='User') or (owner_id in (?) and owner_type='Course')", self.following, self.id, self.courses + self.courses_teached).order('created_at desc')
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
  
  def student_of?(course)
    self.courses.include?(course) && !self.teacher_of?(course)
  end
  
  def teacher_of?(course)
    self.courses_teached.include?(course)
  end
  
end
