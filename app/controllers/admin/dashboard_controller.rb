class Admin::DashboardController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  include Admin::DashboardLoaders

  def index
    @tab = permitted_tab
    @unread_notifications_count = Notification.where(status: false).count

    case @tab
    when 'users'
      load_users
    when 'articles'
      load_articles
    when 'games'
      load_quiz_games
    when 'rewards'
      # placeholders
    when 'notifications'
      load_notifications
    when 'votes'
      load_votes
    when 'players'
      load_players
    else
      # default tab
      @tab = 'users'
      load_users
    end
  end

  def toggle_user_admin
    user = User.find(params[:id])
    user.update!(admin: !user.admin?)
    redirect_to admin_dashboard_path(tab: 'users'), notice: 'Statut admin mis à jour.'
  end

  def mark_notification_read
    notification = Notification.find(params[:notification_id])
    notification.update!(status: true)
    redirect_to admin_dashboard_path(tab: 'notifications'), notice: 'Notification marquée comme lue.'
  end

  def delete_notification
    notification = Notification.find(params[:notification_id])
    notification.destroy!
    redirect_to admin_dashboard_path(tab: 'notifications'), notice: 'Notification supprimée.'
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def permitted_tab
    allowed = %w[users articles games rewards notifications votes players]
    tab = params[:tab].to_s
    allowed.include?(tab) ? tab : 'users'
  end
end
