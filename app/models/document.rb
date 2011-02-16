class Document < ActiveRecord::Base
	belongs_to :course
	attr_accessible :course_id, :name, :file, :description
	mount_uploader :file, FileUploader
	
	def to_s
		self.name
	end
end