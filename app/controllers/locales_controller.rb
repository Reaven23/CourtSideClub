class LocalesController < ApplicationController
  def switch
    locale = params[:locale]

    if I18n.available_locales.include?(locale.to_sym)
      I18n.locale = locale.to_sym
      session[:locale] = locale.to_sym
    else
      I18n.locale = I18n.default_locale
      session[:locale] = I18n.default_locale
    end

    # Rediriger vers la page précédente ou l'accueil
    redirect_back(fallback_location: root_path)
  end
end
