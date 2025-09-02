class NotificationsController < ApplicationController
  before_action :authenticate_user!, only: [:create], unless: :guest_notification?

  def create
    @notification = Notification.new(notification_params)

    if user_signed_in?
      @notification.user = current_user
    end

    if @notification.object == 'news'
      @notification.content = "A user has subscribed to the newsletter: #{@notification.email} "
    end

    @notification.status = false

    if @notification.save!
      redirect_path = determine_redirect_path
      redirect_to redirect_path, notice: "Votre message a été envoyé avec succès ! Nous vous répondrons dans les plus brefs délais."
    else
      flash.now[:alert] = "Erreur lors de l'envoi du message. Veuillez vérifier vos informations."
      render_page = determine_render_page

      if render_page.nil?
        redirect_to(request.referer || root_path, alert: "Erreur lors de l'inscription à la newsletter. Veuillez vérifier votre email.")
      else
        render render_page, status: :unprocessable_entity
      end
    end
  end

  private

  def guest_notification?
    # Permettre les notifications sans authentification pour certains types
    %w[partnership news].include?(params[:notification][:object])
  end

  def determine_redirect_path
    case @notification.object
    when 'partnership'
      partenariat_path
    when 'news'
      request.referer || root_path
    when 'contact'
      contact_path
    else      root_path
    end
  end

  def determine_render_page
    case @notification.object
    when 'partnership'
      'pages/partenariat'
    when 'news'
      nil
    when 'contact'
      'pages/contact'
    else
      'pages/contact'
    end
  end

  def notification_params
    permitted_params = [:object, :content, :phone, :first_name, :last_name, :company, :email]
    params.require(:notification).permit(permitted_params)
  end
end
