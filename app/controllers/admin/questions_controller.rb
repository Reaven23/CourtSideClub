class Admin::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_quiz_game
  before_action :set_question, only: [:edit, :update]

  def index
    @questions = @quiz_game.questions.ordered.includes(:answers)
  end

  def new
    @question = @quiz_game.questions.new
  end

  def create
    @question = @quiz_game.questions.new(question_params)
    if @question.save
      redirect_to admin_quiz_game_questions_path(@quiz_game), notice: 'Question créée.'
    else
      flash.now[:alert] = @question.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to admin_quiz_game_questions_path(@quiz_game), notice: 'Question mise à jour.'
    else
      flash.now[:alert] = @question.errors.full_messages.to_sentence
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
    @question = @quiz_game.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content, :order, :image)
  end
end
