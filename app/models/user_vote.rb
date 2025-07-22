class UserVote < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :vote_campaign
  belongs_to :player

  # Validations
  validates :user_id, uniqueness: { scope: :vote_campaign_id, message: "Vous avez déjà voté dans cette campagne" }
  validate :player_must_be_in_campaign

  # Callbacks
  after_create :award_points_to_user

  private

  def player_must_be_in_campaign
    return unless vote_campaign && player

    unless vote_campaign.players.include?(player)
      errors.add(:player, "n'est pas disponible dans cette campagne de vote")
    end
  end

  def award_points_to_user
    user.add_points!(10) # 10 points par vote
  end
end
