class AuthenticationsController < ApplicationController
		
	def create
	  omniauth = request.env["omniauth.auth"]
	  authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
	  if authentication
			notice = t('auth.signed_in')
	    notice += t('auth.edit_profile') if authentication.user.email.blank?
			flash[:notice] = notice.html_safe 
	    sign_in_and_redirect(:user, authentication.user)
	  else
			name = omniauth['user_info']['name']
			login = omniauth['user_info']['nickname'].blank? ? name.parameterize : omniauth['user_info']['nickname']
			email = omniauth['user_info']['email'] || ""
	    user = User.new(:name => name, :login => login, :email => email)
			user.apply_omniauth(omniauth)
	    if user.save!
      	notice = t('auth.account_created')
		    notice += t('auth.edit_profile') if user.email.blank?
				flash[:notice] = notice.html_safe
      	sign_in_and_redirect(:user, user)
			else
				flash[:error] = t('auth.problem_signing')
				redirect_to new_user_session_path
			end
	  end
	end
	
	def failure
		flash[:error] = t('auth.failure')
		redirect_to root_path
	end
	
	private

	def set_breadcrumbs
	end

end