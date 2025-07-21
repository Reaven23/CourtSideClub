class Level < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :number, presence: true, uniqueness: true, numericality: { greater_than: 0 }
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :ordered, -> { order(:number) }

  # Class methods
  def self.for_points(user_points)
    where('points <= ?', user_points).order(points: :desc).first
  end

  # Instance methods
  def name
    case number
    when 1..5 then "🏀 Rookie #{number}"
    when 6..15 then "⭐ Fan #{number}"
    when 16..30 then "🔥 Super Fan #{number}"
    when 31..50 then "💎 MVP Fan #{number}"
    when 51..75 then "🏆 Legend #{number}"
    when 76..90 then "👑 Elite #{number}"
    when 91..99 then "🌟 Master #{number}"
    when 100 then "🐐 GOAT"
    else "🎯 Level #{number}"
    end
  end

  def next_level
    Level.find_by(number: number + 1)
  end

  def points_to_next_level
    next_level&.points || 0
  end

  def tier_name
    case number
    when 1..5 then "Rookie"
    when 6..15 then "Fan"
    when 16..30 then "Super Fan"
    when 31..50 then "MVP Fan"
    when 51..75 then "Legend"
    when 76..90 then "Elite"
    when 91..99 then "Master"
    when 100 then "GOAT"
    else "Level #{number}"
    end
  end
end
