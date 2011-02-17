class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :define_layout
  
  def paginate( model, options = {} )
    load_page
    model.paginate( { :page => @page, :per_page => @per_page }.merge(options) )
  end

  def load_page
    @page = params[:page] || '1'
    @per_page = params[:per_page].to_i
    if @per_page < 1 || @per_page > 10
      @per_page = 10
    end
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

end
