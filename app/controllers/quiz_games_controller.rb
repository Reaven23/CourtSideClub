class QuizGamesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_quiz_game, only: [:show, :start, :answer, :complete]
  before_action :set_user_quiz_game, only: [:answer, :complete]

  def show
    # Vérifier si l'utilisateur a déjà terminé ce quiz
    @user_completed_game = current_user.user_quiz_games.completed.find_by(quiz_game: @quiz_game)

    if @user_completed_game
      # Rediriger vers les résultats si déjà terminé
      redirect_to mini_games_path, alert: "Vous avez déjà terminé ce quiz !"
      return
    end

    # Récupérer ou créer une session en cours
    @user_quiz_game = current_user.user_quiz_games.find_by(quiz_game: @quiz_game, completed: false)

    # Préparer les données pour le quiz
    @total_questions = @quiz_game.questions.count
    @selected_questions_count = [@total_questions, 10].min # Maximum 10 questions
  end

  def start
    # Créer une nouvelle session de quiz
    @user_quiz_game = current_user.user_quiz_games.create!(
      quiz_game: @quiz_game,
      score: 0,
      completed: false,
      points_earned: 0
    )

    # Sélectionner 10 questions aléatoires (ou moins si le quiz n'en a pas assez)
    selected_questions = @quiz_game.questions.includes(:answers).sample(10)

    render json: {
      success: true,
      user_quiz_game_id: @user_quiz_game.id,
      questions: selected_questions.map.with_index do |question, index|
        {
          id: question.id,
          content: question.content,
          order: index + 1,
          image_url: question.image.attached? ? url_for(question.image) : nil,
          answers: question.answers.ordered.map do |answer|
            {
              id: answer.id,
              content: answer.content,
              order: answer.order
            }
          end
        }
      end,
      quiz_info: {
        title: @quiz_game.title,
        points_per_question: (@quiz_game.points / 10.0).round,
        total_questions: selected_questions.count,
        time_per_question: 24
      }
    }
  end

    def answer
    question = Question.find(params[:question_id])
    answer = Answer.find(params[:answer_id])

    # Vérifier que la réponse appartient bien à la question
    unless question.answers.include?(answer)
      render json: { success: false, error: "Réponse invalide" }
      return
    end

    # Vérifier si l'utilisateur a déjà répondu à cette question
    existing_answer = @user_quiz_game.user_question_answers.find_by(question: question)
    if existing_answer
      render json: { success: false, error: "Vous avez déjà répondu à cette question" }
      return
    end

    # Enregistrer la réponse
    user_answer = @user_quiz_game.user_question_answers.create!(
      question: question,
      answer: answer,
      correct: answer.correct?,
      answered_at: Time.current
    )

    # Calculer les points gagnés pour cette question
    points_earned = 0
    if answer.correct?
      points_earned = (@quiz_game.points / 10.0).round

      # Mettre à jour le score total
      @user_quiz_game.increment!(:score, points_earned)
    end

    render json: {
      success: true,
      correct: answer.correct?,
      points_earned: points_earned,
      correct_answer: question.answers.correct.first.content,
      explanation: answer.correct? ? "Bonne réponse !" : "Mauvaise réponse.",
      current_score: @user_quiz_game.score
    }
  end

  def complete
    # Finaliser le quiz
    total_points = @user_quiz_game.score

    @user_quiz_game.update!(
      completed: true,
      points_earned: total_points
    )

    # Ajouter les points au total de l'utilisateur
    current_user.add_points!(total_points)

    # Vérifier si l'utilisateur a changé de niveau
    level_up = current_user.level_id_previously_changed?

    render json: {
      success: true,
      final_score: total_points,
      total_questions: @user_quiz_game.user_question_answers.count,
      correct_answers: @user_quiz_game.user_question_answers.correct.count,
      level_up: level_up,
      new_level: level_up ? current_user.level.number : nil,
      user_total_points: current_user.points
    }
  end

  private

  def set_quiz_game
    @quiz_game = QuizGame.find(params[:id])
  end

  def set_user_quiz_game
    @user_quiz_game = current_user.user_quiz_games.find(params[:user_quiz_game_id])
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, error: "Session de quiz introuvable" }
  end
end
