class AuthenticationsController < ApplicationController
		
	def create
	  omniauth = request.env["omniauth.auth"]
	  authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
	  if authentication
			notice = t('auth.signed_in')
	    notice += t('auth.edit_profile') if authentication.user.email.blank?
			flash[:notice] = notice.html_safe 
	    sign_in_and_redirect(:user, authentication.user)
		elsif current_user
	    current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
			current_user.add_service_info(omniauth)
	    flash[:notice] = t('auth.successful')
	    redirect_to edit_profile_path
	  else
			user = User.create_from_omniauth(omniauth)
	    if user.save
      	notice = t('auth.account_created')
		    notice += t('auth.edit_profile') if user.email.blank?
				flash[:notice] = notice.html_safe
      	sign_in_and_redirect(:user, user)
			else
				session[:omniauth] = omniauth.except('extra')
				redirect_to new_user_registration_path
			end
	  end
	end
	
	def failure
		flash[:alert] = t('auth.failure')
		redirect_to root_url
	end
	
	def destroy
		@authentication = current_user.authentications.find(params[:id])
		if current_user.authentications.size == 1 && current_user.has_no_password
			flash[:alert] = t('auth.cannot_destroy')
		else
			@authentication.destroy
			flash[:notice] = t('auth.destroyed')
		end
		redirect_to edit_profile_url
	end
	
	private

	def set_breadcrumbs
	end

end