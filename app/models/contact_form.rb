class ContactForm
	include ActiveModel::Validations
	include ActiveModel::Conversion
	
	attr_accessor :name, :email, :text, :honeypot #honeypot field to avoid contact spambots
	
	validates :name, :presence => true, :length => 3..100
	validates :email, :presence => true, :format => /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i
	validates :text, :presence => true, :length => 10..1000
	
	def initialize(attributes = {})
		attributes.each do |name, value|
			self.send("#{name}=", value)
		end
	end
	
	def persisted?
		false
	end
end