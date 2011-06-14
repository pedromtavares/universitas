class Notifications < ActionMailer::Base
	default :to => 'pmtl3000@gmail.com'
	def contact_us(form)
		@form = form
		mail(:reply_to => @form.email, :subject => "Contact from Universitas")
	end
end
