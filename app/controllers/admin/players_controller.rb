class Admin::PlayersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_player, only: [:edit, :update, :destroy]

  def new
    @player = Player.new
  end

  def create
    @player = Player.new(player_params)
    if @player.save
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: [
            turbo_stream.append('players', partial: 'admin/players/player', locals: { player: @player }),
            turbo_stream.update('admin_new_player_form', partial: 'admin/players/form', locals: { player: Player.new })
          ]
        }
        format.html { redirect_to admin_dashboard_path(tab: 'players'), notice: 'Joueur créé avec succès.' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.update('admin_new_player_form', partial: 'admin/players/form', locals: { player: @player }) }
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    if @player.update(player_params)
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@player, partial: 'admin/players/player', locals: { player: @player }) }
        format.html { redirect_to admin_dashboard_path(tab: 'players'), notice: 'Joueur mis à jour avec succès.' }
      end
    else
      render :edit
    end
  end

  def destroy
    @player.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@player) }
      format.html { redirect_to admin_dashboard_path(tab: 'players'), notice: 'Joueur supprimé avec succès.' }
    end
  end

  private

  def set_player
    @player = Player.find(params[:id])
  end

  def player_params
    params.require(:player).permit(:first_name, :last_name, :tournament_played, :photo)
  end

  def ensure_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: 'Accès non autorisé.'
    end
  end
end
