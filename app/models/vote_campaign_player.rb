class VoteCampaignPlayer < ApplicationRecord
  belongs_to :vote_campaign
  belongs_to :player

  validates :vote_campaign_id, uniqueness: { scope: :player_id, message: "Ce joueur est déjà dans cette campagne" }
end
