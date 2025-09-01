class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :level, optional: true

  # Anciennes associations (à conserver pour compatibilité)
  has_many :votes, dependent: :destroy
  has_many :voted_players, through: :votes, source: :player

  # Nouvelles associations pour les campagnes
  has_many :user_votes, dependent: :destroy
  has_many :vote_campaigns, through: :user_votes
  has_many :voted_campaign_players, through: :user_votes, source: :player

  # Associations pour les notifications
  has_many :notifications, dependent: :destroy

  # Associations pour les quiz games
  has_many :user_quiz_games, dependent: :destroy
  has_many :quiz_games, through: :user_quiz_games

  # Associations pour les articles
  has_many :articles, dependent: :destroy

  # Callbacks
  before_save :update_level_if_needed
  after_create :assign_initial_level

  # Validations
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :birthdate, presence: true
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Custom validations
  validate :birthdate_cannot_be_in_future
  validate :user_must_be_at_least_13_years_old

  # Instance methods
  def full_name
    "#{first_name} #{last_name}"
  end

  # Anciennes méthodes (à conserver)
  def has_voted_for?(player)
    votes.exists?(player: player)
  end

  def vote_for!(player)
    return false if has_voted_for?(player)

    votes.create!(player: player)
    add_points!(10)
    true
  end

  # Nouvelles méthodes pour les campagnes
  def has_voted_in_campaign?(vote_campaign)
    user_votes.exists?(vote_campaign: vote_campaign)
  end

  def vote_in_campaign!(vote_campaign, player)
    return false if has_voted_in_campaign?(vote_campaign)
    return false unless vote_campaign.players.include?(player)

    user_votes.create!(vote_campaign: vote_campaign, player: player)
    true
  end

  def vote_in_campaign(vote_campaign)
    user_votes.find_by(vote_campaign: vote_campaign)
  end

  # Points management
  def add_points!(amount)
    old_level = level
    self.points = (points || 0) + amount
    save!

    # Retourner true si le niveau a changé
    reload.level != old_level
  end

  # Level system methods
  def current_level_name
    level&.name || "🏀 Rookie 1"
  end

  def progress_to_next_level
    return 0 unless level&.next_level

    current_progress = points - level.points
    points_needed = level.next_level.points - level.points

    [(current_progress.to_f / points_needed * 100).round, 100].min
  end

  def points_to_next_level
    return 0 unless level&.next_level

    [level.next_level.points - points, 0].max
  end

  def admin?
    admin == true
  end

  private

  def birthdate_cannot_be_in_future
    return unless birthdate

    errors.add(:birthdate, "ne peut pas être dans le futur") if birthdate > Date.current
  end

  def user_must_be_at_least_13_years_old
    return unless birthdate

    min_age = 13
    if birthdate > min_age.years.ago.to_date
      errors.add(:birthdate, "vous devez avoir au moins #{min_age} ans")
    end
  end

  def update_level_if_needed
    return unless points_changed?

    new_level = Level.for_points(points)
    self.level = new_level if new_level != level
  end

  def assign_initial_level
    self.update(level: Level.for_points(points || 0))
  end
end
