class Answer < ApplicationRecord
  belongs_to :question
  has_many :user_question_answers, dependent: :destroy

  validates :content, presence: true
  validates :order, presence: true, numericality: { greater_than: 0 }
  validates :order, uniqueness: { scope: :question_id }

  scope :ordered, -> { order(:order) }
  scope :correct, -> { where(correct: true) }
end
