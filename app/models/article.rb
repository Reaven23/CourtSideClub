class Article < ApplicationRecord
  belongs_to :user
  has_one_attached :photo

  # Relations many-to-many avec les tags
  has_many :article_tags, dependent: :destroy
  has_many :tags, through: :article_tags

  validates :title, presence: true, length: { minimum: 5, maximum: 200 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :youtube_embed, format: {
    with: /\A(https?:\/\/)?(www\.)?(youtube\.com|youtu\.be)\/.+\z/i,
    message: "doit être un lien YouTube valide"
  }, allow_blank: true
  validates :instagram_embed, format: {
    with: /\A(https?:\/\/)?(www\.)?instagram\.com\/.+\z/i,
    message: "doit être un lien Instagram valide"
  }, allow_blank: true

  validate :photo_format

  # Scopes
  scope :published, -> { where.not(published_at: nil) }
  scope :draft, -> { where(published_at: nil) }
  scope :recent, -> { order(published_at: :desc) }
  scope :by_user, ->(user) { where(user: user) }
  scope :with_tag, ->(tag) { joins(:tags).where(tags: { id: tag.id }) }

  # Méthodes d'instance
  def published?
    published_at.present?
  end

  def draft?
    !published?
  end

  def publish!
    update!(published_at: Time.current)
  end

  def unpublish!
    update!(published_at: nil)
  end

  # Méthodes pour gérer les tags
  def tag_names
    tags.pluck(:name)
  end

  def tag_names=(names)
    tag_array = if names.is_a?(String)
      names.split(',').map(&:strip).reject(&:blank?)
    else
      Array(names).compact
    end

    self.tags = tag_array.map do |name|
      Tag.find_or_create_by(name: name.strip.downcase)
    end
  end

  def add_tag(tag_name)
    tag = Tag.find_or_create_by(name: tag_name.strip.downcase)
    tags << tag unless tags.include?(tag)
  end

  def remove_tag(tag_name)
    tag = tags.find_by(name: tag_name.strip.downcase)
    tags.delete(tag) if tag
  end

  # Méthodes pour les embeds
  def youtube_video_id
    return nil unless youtube_embed.present?

    # Extraire l'ID de différents formats d'URL YouTube
    if youtube_embed.match(/(?:youtube\.com\/watch\?v=|youtu\.be\/)([^&\n?#]+)/)
      $1
    end
  end

  def youtube_embed_url
    return nil unless youtube_video_id
    "https://www.youtube.com/embed/#{youtube_video_id}"
  end

  def instagram_embed_url
    return nil unless instagram_embed.present?

    # Nettoyer l'URL Instagram en supprimant les paramètres de tracking
    clean_url = instagram_embed.split('?').first
    clean_url
  end

  def has_media?
    photo.attached? || youtube_embed.present? || instagram_embed.present?
  end

  private

  def photo_format
    return unless photo.attached?

    unless photo.blob.content_type.starts_with?('image/')
      errors.add(:photo, 'doit être une image')
    end
  end
end
