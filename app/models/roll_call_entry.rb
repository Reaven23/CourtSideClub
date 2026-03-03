class RollCallEntry < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name,  presence: true, length: { maximum: 100 }
end

