class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
  end

  def dashboard
    @user = current_user
    @user_votes = @user.votes.includes(:player)
    @total_players = Player.count
    @votes_count = @user.votes.count
    @current_level = @user.level
    @next_level = @current_level&.next_level
  end
end
