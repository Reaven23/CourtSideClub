class Admin::VoteCampaignsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!
  before_action :set_vote_campaign, only: [:show, :edit, :update, :destroy]

  def new
    @vote_campaign = VoteCampaign.new
  end

  def create
    puts "=== CREATE PARAMS ==="
    puts params.inspect
    puts "=== VOTE CAMPAIGN PARAMS ==="
    puts vote_campaign_params.inspect

    @vote_campaign = VoteCampaign.new(vote_campaign_params)
    if @vote_campaign.save
      puts "=== SAVED SUCCESSFULLY ==="
      puts "Players count: #{@vote_campaign.players.count}"
      redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote créée avec succès.'
    else
      puts "=== SAVE FAILED ==="
      puts @vote_campaign.errors.full_messages
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    puts "=== UPDATE PARAMS ==="
    puts params.inspect
    puts "=== VOTE CAMPAIGN PARAMS ==="
    puts vote_campaign_params.inspect
    puts "=== HTTP METHOD ==="
    puts request.method

    if @vote_campaign.update(vote_campaign_params)
      puts "=== UPDATED SUCCESSFULLY ==="
      puts "Players count: #{@vote_campaign.players.count}"
      redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote mise à jour avec succès.'
    else
      puts "=== UPDATE FAILED ==="
      puts @vote_campaign.errors.full_messages
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vote_campaign.destroy
    redirect_to admin_dashboard_path(tab: 'votes'), notice: 'Campagne de vote supprimée avec succès.'
  end

  def test
    render plain: "Controller working! Params: #{params.inspect}"
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Vous n'avez pas les permissions nécessaires." unless current_user.admin?
  end

  def set_vote_campaign
    @vote_campaign = VoteCampaign.find(params[:id])
  end

  def vote_campaign_params
    params.require(:vote_campaign).permit(:title, :description, :start_date, :end_date, :active, player_ids: [])
  end
end
