class Document < ActiveRecord::Base
	belongs_to :course
	attr_accessible :course_id, :name, :file, :description
	mount_uploader :file, FileUploader
	
	validates :name, :presence => true
	validates :file, :presence => true, :length => {:maximum => 5000000, :message => I18n.t('custom_messages.file_validation')}
	
	def to_s
		self.name
	end
end