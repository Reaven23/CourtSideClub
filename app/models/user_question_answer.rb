class UserQuestionAnswer < ApplicationRecord
  belongs_to :user_quiz_game
  belongs_to :question
  belongs_to :answer

  validates :user_quiz_game_id, uniqueness: { scope: :question_id }

  scope :correct, -> { where(correct: true) }
  scope :incorrect, -> { where(correct: false) }
end
