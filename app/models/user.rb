class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
    decrement!(:points, [amount, points].min) # Ne peut pas descendre en dessous de 0
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
end
