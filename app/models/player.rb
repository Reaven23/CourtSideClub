class Player < ApplicationRecord
  # Active Storage
  has_one_attached :photo

  # Associations
  has_many :votes, dependent: :destroy
  has_many :voters, through: :votes, source: :user

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :tournament_played, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  def vote_count
    votes.count
  end

  def voted_by?(user)
    return false unless user
    votes.exists?(user: user)
  end

  def photo_url
    return Rails.application.routes.url_helpers.asset_path('default-player.svg') unless photo.attached?

    Rails.application.routes.url_helpers.rails_blob_path(photo, only_path: true)
  end

  private

  def photo_format
    return unless photo.attached?

    unless photo.blob.content_type.in?(['image/jpeg', 'image/jpg', 'image/png', 'image/webp'])
      errors.add(:photo, 'doit être un fichier JPEG, PNG ou WebP')
    end

    if photo.blob.byte_size > 5.megabytes
      errors.add(:photo, 'doit faire moins de 5MB')
    end
  end
end
