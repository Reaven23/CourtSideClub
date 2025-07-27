class MiniGamesController < ApplicationController
  before_action :authenticate_user!

  def index
    @quiz_games = QuizGame.active.includes(:questions)
    @user_completed_games = current_user.user_quiz_games.completed.includes(:quiz_game)
  end
end
