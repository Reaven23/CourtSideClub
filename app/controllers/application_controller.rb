class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_unread_notifications_count, if: :user_signed_in?
  before_action :set_locale
  include Pundit::Authorization

  private

        def configure_permitted_parameters
          # Paramètres autorisés pour l'inscription
          devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :birthdate, :photo])

          # Paramètres autorisés pour la mise à jour du compte
          devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :birthdate, :photo])
        end

  def set_unread_notifications_count
    @unread_notifications_count = Notification.where(status: false).count
  end

  def set_locale
    I18n.locale = session[:locale] || I18n.default_locale
  end
end
