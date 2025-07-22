class VoteCampaign < ApplicationRecord
  # Associations
  has_many :vote_campaign_players, dependent: :destroy
  has_many :players, through: :vote_campaign_players
  has_many :user_votes, dependent: :destroy
  has_many :users, through: :user_votes

  # Validations
  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10 }
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_date_after_start_date

  # Scopes
  scope :active, -> { where(active: true) }
  scope :current, -> { where('start_date <= ? AND end_date >= ?', Time.current, Time.current) }
  scope :upcoming, -> { where('start_date > ?', Time.current) }
  scope :past, -> { where('end_date < ?', Time.current) }

  # Instance methods
  def current?
    start_date <= Time.current && end_date >= Time.current
  end

  def upcoming?
    start_date > Time.current
  end

  def past?
    end_date < Time.current
  end

  def user_voted?(user)
    user_votes.exists?(user: user)
  end

  def vote_count
    user_votes.count
  end

  def vote_count_for_player(player)
    user_votes.where(player: player).count
  end

  private

  def end_date_after_start_date
    return unless start_date && end_date

    errors.add(:end_date, "doit être après la date de début") if end_date <= start_date
  end
end
