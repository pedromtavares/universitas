class Document < ActiveRecord::Base
	belongs_to :uploader, :class_name => "User", :foreign_key => 'user_id'
	has_many :user_documents, :dependent => :destroy
	has_many :group_documents, :dependent => :destroy
	has_many :users, :through => :user_documents
	has_many :groups, :through => :group_documents
	has_many :comments, :as => :target, :dependent => :destroy
	
	has_friendly_id :name, :use_slug => true
	
	attr_accessible :uploader, :name, :file, :description, :file_size, :scribd_doc_id, :scribd_access_key, :content_type, :extension
	
	# remove this after carrierwave merges this feature into master
	before_update :store_previous_file
	after_save :remove_stored_file
	
	mount_uploader :file, FileUploader
	
	ALLOWED_FILE_EXTENSIONS = %w(jpg jpeg gif png doc docx xls xlsx ppt pptx pdf txt)
	MAXIMUM_FILE_SIZE = 50000000
	MAXIMUM_FILE_SIZE_MB = MAXIMUM_FILE_SIZE/1000000
	
	validates :name, :presence => true, :length => { :minimum => 4, :maximum => 100 }
	validates :file, :length => {:maximum => MAXIMUM_FILE_SIZE, :message => I18n.t('custom_messages.file_validation', :size => MAXIMUM_FILE_SIZE_MB)}, :if => lambda { self.file.present? }
	validates :description, :length => {:maximum => 1000}
	
	scope :recent, order('created_at desc').limit(5)
	
	def to_s
		self.name
	end
	
	def extension
	  if self.file.present?
		  self.file_url.split('.').last.downcase
	  else
	    self.read_attribute(:extension)
    end
	end
	
	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end
	
	def self.get_extension_from(filename)
	  filename.split('.').last
	end
	
	def self.is_image?(extension)
	  if ['png','gif', 'jpg', 'jpeg'].include?(extension)
	    true
    else
      false
    end
	end
	
	def self.create_from_scribd(name, file, user, content_type)
	  extension = self.get_extension_from(file.original_filename)
	  result = Scribd.new.upload(file, extension)
	  if result && result[:doc_id] && result[:access_key]
	    Document.create(:name => name, :uploader => user, :file_size => file.size, :content_type => content_type, :scribd_doc_id => result[:doc_id], :scribd_access_key => result[:access_key], :extension => extension)
    else
      false
    end
	end
  
  private

	def store_previous_file
		@stored = Document.find(self.id) if self.file_changed?
	end

	def remove_stored_file
		@stored.remove_file! if @stored
	end
	
end

# == Schema Information
#
# Table name: documents
#
#  id                :integer(4)      not null, primary key
#  name              :string(255)
#  description       :text
#  file              :string(255)
#  user_id           :integer(4)
#  content_type      :string(255)
#  file_size         :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#  scribd_doc_id     :string(255)
#  scribd_access_key :string(255)
#  extension         :string(255)
#

