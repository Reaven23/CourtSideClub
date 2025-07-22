class VoteCampaignsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_vote_campaign, only: [:show, :vote]

  def index
    @active_campaigns = VoteCampaign.active.current.includes(:players, :user_votes)
    @upcoming_campaigns = VoteCampaign.active.upcoming.includes(:players)
    @past_campaigns = VoteCampaign.active.past.includes(:players, :user_votes)
  end

  def show
    @players = @vote_campaign.players.includes(:user_votes)
    @user_vote = current_user&.user_votes&.find_by(vote_campaign: @vote_campaign)
    @vote_counts = @vote_campaign.user_votes.group(:player_id).count
  end

  def vote
    @player = Player.find(params[:player_id])

    # Vérifier que le joueur fait partie de la campagne
    unless @vote_campaign.players.include?(@player)
      redirect_to @vote_campaign, alert: "Ce joueur ne fait pas partie de cette campagne."
      return
    end

    # Vérifier que l'utilisateur n'a pas déjà voté
    if current_user.has_voted_in_campaign?(@vote_campaign)
      redirect_to @vote_campaign, alert: "Vous avez déjà voté dans cette campagne."
      return
    end

    # Créer le vote
    if current_user.vote_in_campaign!(@vote_campaign, @player)
      redirect_to @vote_campaign, notice: "Merci pour votre vote ! Vous avez gagné 10 points."
    else
      redirect_to @vote_campaign, alert: "Une erreur s'est produite lors du vote."
    end
  end

  private

  def set_vote_campaign
    @vote_campaign = VoteCampaign.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to vote_campaigns_path, alert: "Campagne de vote introuvable."
  end
end
