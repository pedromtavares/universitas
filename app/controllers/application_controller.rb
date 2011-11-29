class ApplicationController < ActionController::Base
	include LocalizedSystem
	
  protect_from_forgery
  layout :define_layout
    
  def paginate(model, per=30)
    @page = params[:page]
    model.page(@page).per(per)
  end

	private
	# so signin and signup pages share the simple layout box
	def define_layout
		if self.is_a?(Devise::SessionsController) || self.is_a?(Devise::PasswordsController) || (self.is_a?(Devise::RegistrationsController) && (self.action_name == 'new' || self.action_name == 'create') )
			"simple"
		else
			"application"
		end
	end

end
