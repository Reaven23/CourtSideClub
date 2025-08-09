class QuizGame < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :user_quiz_games, dependent: :destroy
  has_many :users, through: :user_quiz_games

  validates :title, presence: true
  validates :points_per_question, presence: true, numericality: { only_integer: true, greater_than: 0 }

  scope :active, -> { where(active: true) }
end
