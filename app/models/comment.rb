class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, :polymorphic => true
  has_many :targeted_updates, :as => :target, :dependent => :destroy, :class_name => "Update"
  
  validates :text, :presence => true, :allow_blank => false, :length => 2..10000
  
  after_create :create_update
	
	def create_update
		self.user.updates.create(:target => self)
	end
	
end
# == Schema Information
#
# Table name: comments
#
#  id          :integer(4)      not null, primary key
#  user_id     :integer(4)
#  target_id   :integer(4)
#  target_type :string(255)
#  text        :text
#  created_at  :datetime
#  updated_at  :datetime
#

