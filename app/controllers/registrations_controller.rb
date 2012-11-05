class RegistrationsController < Devise::RegistrationsController
  def create
    unless params[:honeypot].blank?
      redirect_to root_path 
    else
      super
      session[:omniauth] = nil unless @user.new_record?
    end
  end

  def edit
    @authentications = resource.authentications
    super
  end

  private
  
  def build_resource(*args)
    super
    if session[:omniauth]
      omniauth = session[:omniauth]
      @user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    end
  end
  
  def after_update_path_for(resource)
    edit_profile_path
  end
end