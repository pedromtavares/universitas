# == Schema Information
# Schema version: 20110227225207
#
# Table name: group_modules
#
#  id          :integer(4)      not null, primary key
#  group_id    :integer(4)
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class GroupModule < ActiveRecord::Base
	belongs_to :group, :counter_cache => :modules_count
	has_many :group_documents
	
	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 50 }
	validates :description, :length => { :minimum => 4, :maximum => 200 }
	
	after_create :create_forum
	
	def self.blank_module
		self.new(:name => I18n.t('groups.documents.blank_prompt'))
	end
	
	
	private
	
	def create_forum
		self.group.forums.create(:title => self.name, :description => self.description)
	end
end
