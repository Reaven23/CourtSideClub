class UserQuizGame < ApplicationRecord
  belongs_to :user
  belongs_to :quiz_game
  has_many :user_question_answers, dependent: :destroy

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :points_earned, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :completed, -> { where(completed: true) }
  scope :in_progress, -> { where(completed: false) }
end
