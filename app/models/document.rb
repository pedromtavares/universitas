# == Schema Information
# Schema version: 20110227225207
#
# Table name: documents
#
#  id           :integer(4)      not null, primary key
#  name         :string(255)
#  description  :text
#  file         :string(255)
#  user_id      :integer(4)
#  content_type :string(255)
#  file_size    :integer(4)
#  created_at   :datetime
#  updated_at   :datetime
#

class Document < ActiveRecord::Base
	belongs_to :uploader, :class_name => "User", :foreign_key => 'user_id'
	has_many :user_documents, :dependent => :destroy
	has_many :group_documents, :dependent => :destroy
	has_many :users, :through => :user_documents
	
	
	attr_accessible :uploader, :name, :file, :description
	before_save :set_file_attributes
	
	# remove this after carrierwave merges this feature into master
	before_update :store_previous_file
	after_save :remove_stored_file
	
	mount_uploader :file, FileUploader
	
	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 100 }
	validates :file, :presence => true, :length => {:maximum => 10000000, :message => I18n.t('custom_messages.file_validation')}
	validates :description, :length => {:maximum => 1000}
	
	def to_s
		self.name
	end
	
	def extension
		self.file_url.split('.').last.downcase
	end
	
	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end
	
	private 
	
  def set_file_attributes 
    self.content_type = self.file.file.content_type 
    self.file_size = self.file.size 
  end

	def store_previous_file
		@stored = Document.find(self.id) if self.file_changed?
	end

	def remove_stored_file
		@stored.remove_file! if @stored
	end
	
end
