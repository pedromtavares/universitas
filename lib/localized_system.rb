module LocalizedSystem
  
  LOCALES = ['en', 'pt']

  extend ActiveSupport::Memoizable

  module ClassMethods

    def disable_locale
      skip_before_filter :set_locale
      before_filter :set_locale_to_default
    end

  end

  def self.included(  base )
    base.before_filter :set_locale
    base.helper_method :current_locale, :t, :l
    base.extend( LocalizedSystem::ClassMethods )
  end

  def t( *args )
    I18n.t(*args)
  end

  def l( *args )
    I18n.l(*args)
  end

  def set_locale_to_default
    I18n.locale = I18n.default_locale
  end

  def set_locale
    params[:locale] = false unless params[:locale].present? && LOCALES.include?(params[:locale])
    I18n.locale = cookies.permanent[:locale] = params[:locale] || cookies[:locale] || I18n.default_locale
		current_user.update_attribute(:locale, I18n.locale) unless current_user.blank?
  end

  def current_locale
    I18n.locale
  end

  memoize :current_locale

  def change_locale( locale )
    cookies.permanent[:locale] = locale
  end

end