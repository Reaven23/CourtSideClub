class Admin::QuestionsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_quiz_game
  before_action :set_question, only: [:edit, :update, :destroy]

  def index
    @questions = @quiz_game.questions.ordered.includes(:answers)
  end

  def new
    @question = @quiz_game.questions.new
    4.times { |i| @question.answers.build(order: i + 1) }
  end

  def create
    @question = @quiz_game.questions.new(question_params)
    set_correct_answer_from_index
    if @question.save
      redirect_to admin_quiz_game_questions_path(@quiz_game), notice: 'Question créée.'
    else
      flash.now[:alert] = @question.errors.full_messages.to_sentence
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Ensure the form always shows 4 answers
    answers_needed = 4 - @question.answers.size
    answers_needed.times do
      @question.answers.build(order: (@question.answers.size + 1))
    end
  end

  def update
    @question.assign_attributes(question_params)
    set_correct_answer_from_index
    if @question.save
      redirect_to admin_quiz_game_questions_path(@quiz_game), notice: 'Question mise à jour.'
    else
      flash.now[:alert] = @question.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy
    redirect_to admin_quiz_game_questions_path(@quiz_game), notice: 'Question supprimée.'
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
    params.require(:question).permit(:content, :order, :image, answers_attributes: [:id, :content, :order, :correct, :_destroy])
  end

  def set_correct_answer_from_index
    index = params.dig(:question, :correct_index)
    return if index.blank?

    # Reset correctness
    @question.answers.each { |a| a.correct = false }
    # Mark the selected as correct (index is 0-based in form)
    selected = @question.answers[index.to_i]
    selected.correct = true if selected
  end
end
