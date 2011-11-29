class AboutController < ApplicationController
  def show
		@contact_form = ContactForm.new
  end

	def create
		@contact_form = ContactForm.new(params[:contact_form])
		
		if @contact_form.valid?
			Notifications.contact_us(@contact_form).deliver unless @contact_form.honeypot.present?
			redirect_to about_path, :notice => t('about.success')
		else
			flash.now[:alert] = t('about.error')
			render :show
		end
	end
end
