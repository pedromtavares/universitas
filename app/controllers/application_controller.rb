class ApplicationController < ActionController::Base
	include LocalizedSystem
	
  protect_from_forgery
  layout :define_layout
	before_filter :set_breadcrumbs
  
  def paginate(model, per=10)
    model.page(params[:page]).per(per)
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
	
	def set_breadcrumbs
		add_breadcrumb(parent.name.truncate(50), :parent_url) if self.respond_to?('parent?') && parent?
		add_breadcrumb(I18n.t("#{self.controller_name}.all"), :collection_path)
		add_breadcrumb(I18n.t("#{self.controller_name}.new"), :new_resource_path)
		add_breadcrumb(resource.to_s.truncate(50), lambda { |a| resource_path  }) if params[:id]
	end
	
	def after_sign_in_path_for(resource)
		dashboard_path
	end

end
