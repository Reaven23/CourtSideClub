class Tag < ApplicationRecord
  has_many :article_tags, dependent: :destroy
  has_many :articles, through: :article_tags

  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 50 }
  validates :color, format: { with: /\A#[0-9a-fA-F]{6}\z/, message: "doit être un code couleur hexadécimal valide (ex: #ee53a8)" }
  validates :description, length: { maximum: 200 }

  # Callbacks
  before_save :normalize_name
  before_save :normalize_color

  # Scopes
  scope :popular, -> { joins(:articles).group('tags.id').order('COUNT(articles.id) DESC') }
  scope :alphabetical, -> { order(:name) }

  # Méthodes d'instance
  def articles_count
    articles.published.count
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  private

  def normalize_name
    self.name = name.strip.downcase
  end

  def normalize_color
    self.color = color.downcase if color.present?
  end
end
