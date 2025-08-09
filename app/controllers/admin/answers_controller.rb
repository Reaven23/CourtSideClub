class Admin::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_quiz_game
  before_action :set_question
  before_action :set_answer, only: [:edit, :update]

  def index
    @answers = @question.answers.ordered
  end

  def new
    @answer = @question.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to admin_quiz_game_question_answers_path(@quiz_game, @question), notice: 'Réponse créée.'
    else
      flash.now[:alert] = @answer.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @answer.update(answer_params)
      redirect_to admin_quiz_game_question_answers_path(@quiz_game, @question), notice: 'Réponse mise à jour.'
    else
      flash.now[:alert] = @answer.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def set_quiz_game
    @quiz_game = QuizGame.find(params[:quiz_game_id])
  end

  def set_question
    @question = @quiz_game.questions.find(params[:question_id])
  end

  def set_answer
    @answer = @question.answers.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:content, :order, :correct)
  end
end
