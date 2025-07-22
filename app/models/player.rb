class Player < ApplicationRecord
  # Active Storage
  has_one_attached :photo

  # Associations
  # Anciennes associations (à conserver pour compatibilité)
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  # Nouvelles associations pour les campagnes
  has_many :vote_campaign_players, dependent: :destroy
  has_many :vote_campaigns, through: :vote_campaign_players
  has_many :user_votes, dependent: :destroy
  has_many :campaign_voters, through: :user_votes, source: :user

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :tournament_played, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :photo_format

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  # Anciennes méthodes (à conserver)
  def vote_count
    votes.count
  end

  def voted_by?(user)
    votes.exists?(user: user)
  end

  # Nouvelles méthodes pour les campagnes
  def vote_count_in_campaign(vote_campaign)
    user_votes.where(vote_campaign: vote_campaign).count
  end

  def voted_by_in_campaign?(user, vote_campaign)
    user_votes.exists?(user: user, vote_campaign: vote_campaign)
  end

  def total_campaign_votes
    user_votes.count
  end

  def photo_url
    if photo.attached?
      Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
    else
      # SVG par défaut
      "data:image/svg+xml;base64,#{Base64.strict_encode64(default_player_svg)}"
    end
  end

  private

  def photo_format
    return unless photo.attached?

    unless photo.content_type.in?(['image/jpeg', 'image/png', 'image/webp'])
      errors.add(:photo, 'doit être un fichier JPEG, PNG ou WebP')
    end

    if photo.byte_size > 5.megabytes
      errors.add(:photo, 'doit faire moins de 5MB')
    end
  end

  def default_player_svg
    <<~SVG
      <svg viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="bg" x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0%" style="stop-color:#EE53A8;stop-opacity:1" />
            <stop offset="100%" style="stop-color:#8a2be2;stop-opacity:1" />
          </linearGradient>
        </defs>
        <rect width="100" height="100" fill="url(#bg)" rx="10"/>
        <text x="50" y="60" text-anchor="middle" fill="white" font-size="40" font-family="Arial">?</text>
      </svg>
    SVG
  end
end
