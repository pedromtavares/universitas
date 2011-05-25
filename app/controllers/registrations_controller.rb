class RegistrationsController < Devise::RegistrationsController
	before_filter :load_presenter
  def create
    super
    session[:omniauth] = nil unless @user.new_record?
  end

	def edit
		@authentications = resource.authentications
		super
	end

  private

	def load_presenter
		@presenter = RegistrationsPresenter.new(current_user)
	end
  
  def build_resource(*args)
    super
    if session[:omniauth]
			omniauth = session[:omniauth]
      @user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
    end
  end
end