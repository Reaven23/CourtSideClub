class Question < ApplicationRecord
  belongs_to :quiz_game
  has_many :answers, dependent: :destroy
  has_many :user_question_answers, dependent: :destroy
  has_one_attached :image

  validates :content, presence: true
  validates :order, presence: true, numericality: { greater_than: 0 }
  validates :order, uniqueness: { scope: :quiz_game_id }

  scope :ordered, -> { order(:order) }

  # Validation pour le format d'image
  validate :image_format, if: -> { image.attached? }

  private

  def image_format
    return unless image.attached?

    unless image.blob.content_type.starts_with?('image/')
      errors.add(:image, 'doit être une image')
    end
  end
end
