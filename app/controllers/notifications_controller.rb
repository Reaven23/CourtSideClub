class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @notification = Notification.new(notification_params)
    @notification.user = current_user
    @notification.object = params[:notification][:object]
    @notification.status = false

    if @notification.save
      redirect_to contact_path, notice: "Votre message a été envoyé avec succès ! Nous vous répondrons dans les plus brefs délais."
    else
      flash.now[:alert] = "Erreur lors de l'envoi du message. Veuillez vérifier vos informations."
      render "pages/contact", status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:object, :content)
  end
end
