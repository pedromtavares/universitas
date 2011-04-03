# == Schema Information
# Schema version: 20110227225207
#
# Table name: documents
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  file        :string(255)
#  user_id     :integer(4)
#  created_at  :datetime
#  updated_at  :datetime
#

class Document < ActiveRecord::Base
	belongs_to :uploader, :class_name => "User", :foreign_key => 'user_id'
	has_many :user_documents
	has_many :group_documents
	attr_accessible :uploader, :name, :file, :description
	after_create :create_user_document
	mount_uploader :file, FileUploader

	
	validates :name, :presence => true
	validates :file, :presence => true, :length => {:maximum => 10000000, :message => I18n.t('custom_messages.file_validation')}
	
	def to_s
		self.name
	end
	
	def self.search(search)
		self.where("name like ?", "%#{search}%")
	end
	
	private
	
	def create_user_document
		puts self.inspect
		UserDocument.create(:user => self.uploader, :document => self)
	end
	
end
