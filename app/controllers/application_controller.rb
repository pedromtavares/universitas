class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :define_layout

	before_filter :set_breadcrumbs
  
  def paginate(model)
    model.page(params[:page]).per(10)
  end

	private
	# so signin and signup pages share the simple layout box
	def define_layout
		if self.is_a?(Devise::SessionsController) || (self.is_a?(Devise::RegistrationsController) && (self.action_name == 'new' || self.action_name == 'create') )
			"simple"
		else
			"application"
		end
	end
	
	def set_breadcrumbs
		add_breadcrumb(parent.name, :parent_url) if self.respond_to?('parent?') && parent?
		add_breadcrumb(I18n.t("#{self.controller_name}.all"), :collection_path)
		add_breadcrumb(I18n.t("#{self.controller_name}.new"), :new_resource_path)
		add_breadcrumb(resource.to_s, lambda { |a| resource_path  }) if params[:id]
	end

end
