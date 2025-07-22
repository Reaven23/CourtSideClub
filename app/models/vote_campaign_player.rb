class VoteCampaignPlayer < ApplicationRecord
  # Associations
  belongs_to :vote_campaign
  belongs_to :player

  # Validations
  validates :vote_campaign_id, uniqueness: { scope: :player_id, message: "Ce joueur est déjà dans cette campagne" }
end
