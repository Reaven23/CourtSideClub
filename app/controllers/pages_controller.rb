class PagesController < ApplicationController
  before_action :authenticate_user!, only: [:dashboard]

  def home
    @latest_articles = Article.published.order(published_at: :desc).limit(8)
  end

  def dashboard
    @user = current_user
    @current_level = @user.level
    @next_level = @current_level&.next_level
    @user_votes = @user.votes.includes(:player).limit(6)
    @votes_count = @user.votes.count

    # Vote campaigns
    @current_vote_campaign = VoteCampaign.active.current.first
    @user_vote_in_current_campaign = @current_vote_campaign ? @user.user_votes.find_by(vote_campaign: @current_vote_campaign) : nil

    # Check for pending votes
    @current_vote_campaigns = VoteCampaign.active.current
    @has_pending_votes = @current_vote_campaigns.any? { |campaign| !campaign.user_voted?(@user) }
  end

  def contact
    @notification = Notification.new
  end

  def advantages
  end

  def historique
    @user_votes = current_user.user_votes.includes(:vote_campaign, :player).order(created_at: :desc)
    @user_quiz_games = current_user.user_quiz_games.includes(:quiz_game).order(created_at: :desc)

    # Combiner et trier toutes les activités par date
    @activities = []

    @user_votes.each do |vote|
      @activities << {
        type: 'vote',
        date: vote.created_at,
        title: "Vote pour #{vote.player.full_name}",
        description: "Campagne: #{vote.vote_campaign.title}",
        points: 10,
        icon: 'fas fa-vote-yea',
        color: 'primary'
      }
    end

    @user_quiz_games.each do |quiz|
      @activities << {
        type: 'quiz',
        date: quiz.created_at,
        title: "Quiz: #{quiz.quiz_game.title}",
        description: "Score: #{quiz.score}/#{quiz.quiz_game.questions.count}",
        points: quiz.points_earned,
        icon: 'fas fa-brain',
        color: 'success'
      }
    end

    # Trier par date décroissante
    @activities.sort_by! { |activity| activity[:date] }.reverse!
  end

  def discover
  end
end
