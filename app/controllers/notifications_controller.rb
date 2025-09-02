class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:create], unless: :guest_notification?

  def create
    @notification = Notification.new(notification_params)

    if user_signed_in?
      @notification.user = current_user
    end

    @notification.status = false

    if @notification.save
      redirect_path = determine_redirect_path
      redirect_to redirect_path, notice: "Votre message a été envoyé avec succès ! Nous vous répondrons dans les plus brefs délais."
    else
      flash.now[:alert] = "Erreur lors de l'envoi du message. Veuillez vérifier vos informations."
      render_page = determine_render_page
      render render_page, status: :unprocessable_entity
    end
  end

  private

  def guest_notification?
    # Permettre les notifications sans authentification pour certains types
    %w[contact partnership].include?(params[:notification][:object])
  end

  def determine_redirect_path
    case @notification.object
    when 'partnership'
      partenariat_path
    else
      contact_path
    end
  end

  def determine_render_page
    case @notification.object
    when 'partnership'
      'pages/partenariat'
    else
      'pages/contact'
    end
  end

  def notification_params
    permitted_params = [:object, :content, :phone, :first_name, :last_name, :company, :email]
    params.require(:notification).permit(permitted_params)
  end
end
