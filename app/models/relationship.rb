class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  belongs_to :follower, :foreign_key => "follower_id", :class_name => "User"
  belongs_to :followed, :foreign_key => "followed_id", :class_name => "User"
  
  validates :follower_id, :presence => true
  validates :followed_id, :presence => true
end


# == Schema Information
#
# Table name: relationships
#
#  id          :integer(4)      not null, primary key
#  follower_id :integer(4)
#  followed_id :integer(4)
#  blocked     :boolean(1)      default(FALSE)
#  created_at  :datetime
#  updated_at  :datetime
#

