class RegistrationsController < Devise::RegistrationsController
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
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
end