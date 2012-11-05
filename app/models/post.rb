# == Schema Information
# Schema version: 20110227225207
#
# Table name: posts
#
#  id         :integer(4)      not null, primary key
#  topic_id   :integer(4)
#  user_id    :integer(4)
#  text       :text
#  ancestry   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Post < ActiveRecord::Base
  belongs_to :topic, :counter_cache => :posts_count
  belongs_to :author, :class_name => "User", :foreign_key => "user_id"
  has_ancestry :orphan_strategy => :rootify
  validates :text, :presence => true, :allow_blank => false, :length => 2..10000
  has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
  
  after_create :create_update
  
  def create_update
    self.topic.forum.group.updates.create(:target => self) unless self == self.topic.first_post
  end
end
