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
  has_many :updates
  has_many :students
  has_many :courses, :through => :students
  has_many :courses_teached, :class_name => 'Course', :foreign_key => "teacher_id"
  
  def to_s
    self.login
  end
  
  def update_status(msg)
    self.update_attribute :status, msg
    Update.new_status(self, msg)
  end
  
  def feed
    result = Update.arel_table
    Update.where(result[:user_id].in(self.following).or(result[:user_id].eq(self.id.to_s))).order('updated_at desc')  
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
  
  def student_of?(course)
    self.courses.include?(course) && !self.teacher_of?(course)
  end
  
  def teacher_of?(course)
    self.courses_teached.include?(course)
  end
  
end
