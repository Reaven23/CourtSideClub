class Admin::QuizGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_quiz_game, only: [:edit, :update, :destroy]

  def index
    redirect_to admin_dashboard_path(tab: 'games')
  end

  def create
    @quiz_game = QuizGame.new(quiz_game_params)
    if @quiz_game.save
      redirect_to admin_dashboard_path(tab: 'games'), notice: 'Jeu créé.'
    else
      flash[:alert] = @quiz_game.errors.full_messages.to_sentence
      redirect_to admin_dashboard_path(tab: 'games')
    end
  end

  def edit; end

  def update
    if @quiz_game.update(quiz_game_params)
      redirect_to admin_dashboard_path(tab: 'games'), notice: 'Jeu mis à jour.'
    else
      flash.now[:alert] = @quiz_game.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz_game.destroy
    redirect_to admin_dashboard_path(tab: 'games'), notice: 'Jeu supprimé.'
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def set_quiz_game
    @quiz_game = QuizGame.find(params[:id])
  end

  def quiz_game_params
    params.require(:quiz_game).permit(:title, :description, :points_per_question, :active)
  end
end
