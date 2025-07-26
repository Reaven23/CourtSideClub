class QuizGame < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :user_quiz_games, dependent: :destroy
  has_many :users, through: :user_quiz_games

  validates :title, presence: true
  validates :score, presence: true, numericality: { greater_than: 0 }
  validates :points, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where(active: true) }
end
