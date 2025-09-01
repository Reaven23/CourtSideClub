class NotificationsController < ApplicationController
  def create
    @notification = Notification.new(notification_params)
    @notification.user = current_user
    if @notification.save!
      redirect_to root_path, notice: "Notification envoyée avec succès"
    else
      render "pages/contact", status: :unprocessable_entity
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:object, :content)
  end
end
