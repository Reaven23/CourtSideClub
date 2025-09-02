class Notification < ApplicationRecord
  belongs_to :user

  validates :object, presence: true
  validates :content, presence: true
  
end
