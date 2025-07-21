class Vote < ApplicationRecord
  belongs_to :player
  belongs_to :user

  # Validations - Un utilisateur ne peut voter qu'une seule fois pour un joueur
  validates :user_id, uniqueness: { scope: :player_id, message: "a déjà voté pour ce joueur" }
end
