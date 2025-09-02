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

  def discover
  end
end
