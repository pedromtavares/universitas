class Document < ActiveRecord::Base
	belongs_to :uploader, :class_name => "User", :foreign_key => 'user_id'
	has_many :user_documents
	has_many :group_documents
	attr_accessible :user_id, :name, :file, :description
	mount_uploader :file, FileUploader

	
	validates :name, :presence => true
	validates :file, :presence => true, :length => {:maximum => 10000000, :message => I18n.t('custom_messages.file_validation')}
	
	def to_s
		self.name
	end
	
	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end
	
end