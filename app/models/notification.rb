class Notification < ApplicationRecord
  belongs_to :user, optional: true

  validates :object, presence: true
  validates :content, presence: true

  # Validations pour les utilisateurs non connectés
  validates :first_name, presence: true, unless: :user_present?
  validates :last_name, presence: true, unless: :user_present?
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, unless: :user_present?
  validates :company, presence: true, if: :partnership_notification?

  # Méthodes d'aide
  def user_present?
    user.present?
  end

  def partnership_notification?
    object == 'partnership'
  end

  def full_name
    if user_present?
      user.full_name
    else
      "#{first_name} #{last_name}".strip
    end
  end

  def contact_email
    user_present? ? user.email : email
  end
end
