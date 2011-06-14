class Notifications < ActionMailer::Base
	default :to => 'pmtl3000@gmail.com'
	def contact_us(form)
		@form = form
		mail(:from => "#{@form.name} <#{@form.email}>", :reply_to => "#{@form.name} <#{@form.email}>", :subject => "Contact from Universitas")
	end
end
