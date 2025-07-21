class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :level, optional: true
  has_many :votes, dependent: :destroy
  has_many :voted_players, through: :votes, source: :player

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

  def age
    return nil unless birthdate
    ((Date.current - birthdate) / 365.25).floor
  end

  def add_points(amount)
    increment!(:points, amount)
  end

  def remove_points(amount)
    decrement!(:points, [amount, points].min)
  end


  def current_level_name
    level&.name || Level.find_by(number: 1)&.name || "🏀 Rookie 1"
  end

  def progress_to_next_level
    return 100 if level.nil?

    next_level = level.next_level
    return 100 unless next_level

    current_level_points = level.points
    next_level_points = next_level.points
    points_needed = next_level_points - current_level_points
    user_progress = [points - current_level_points, 0].max

    [(user_progress.to_f / points_needed * 100).round, 100].min
  end

  def points_to_next_level
    return 0 if level.nil?

    next_level = level.next_level
    return 0 unless next_level

    [next_level.points - points, 0].max
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

    appropriate_level = Level.for_points(points)
    self.level = appropriate_level if appropriate_level != level
  end

  def assign_initial_level
    self.update(level: Level.for_points(points))
  end
end
