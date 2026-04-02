class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def unit_price
    unit_price_cents / 100.0
  end

  def subtotal_cents
    unit_price_cents * quantity
  end

  def subtotal
    subtotal_cents / 100.0
  end
end
