class Document < ActiveRecord::Base
	belongs_to :course
	has_many :update_references, :as => :reference, :dependent => :destroy, :class_name => "Update"
	attr_accessible :course_id, :name, :file, :description
	mount_uploader :file, FileUploader
	
	after_create :status_update
	
	validates :name, :presence => true
	validates :file, :presence => true, :length => {:maximum => 5000000, :message => I18n.t('custom_messages.file_validation')}
	
	def to_s
		self.name
	end
	
	def status_update
		self.course.updates.create!(:reference => self)
	end
end