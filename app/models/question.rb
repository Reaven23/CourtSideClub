class Question < ApplicationRecord
  belongs_to :quiz_game
  has_many :answers, dependent: :destroy
  has_many :user_question_answers, dependent: :destroy

  validates :content, presence: true
  validates :order, presence: true, numericality: { greater_than: 0 }
  validates :order, uniqueness: { scope: :quiz_game_id }

  scope :ordered, -> { order(:order) }
end
