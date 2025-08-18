class Admin::VoteCampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_vote_campaign, only: [:show, :edit, :update, :destroy]

  def new
    @vote_campaign = VoteCampaign.new
  end

  def create
    @vote_campaign = VoteCampaign.new(vote_campaign_params)

    if @vote_campaign.save
      redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote créée avec succès.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @vote_campaign.update(vote_campaign_params)
      redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote mise à jour avec succès.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vote_campaign.destroy
    redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote supprimée avec succès.'
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def set_vote_campaign
    @vote_campaign = VoteCampaign.find(params[:id])
  end

  def vote_campaign_params
    # Filtrer les player_ids vides pour éviter les erreurs
    filtered_params = params.require(:vote_campaign).permit(:title, :description, :start_date, :end_date, :active, player_ids: [])

    # Supprimer les player_ids vides
    if filtered_params[:player_ids]
      filtered_params[:player_ids] = filtered_params[:player_ids].reject(&:blank?)
    end

    filtered_params
  end
end
