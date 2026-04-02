class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :stock, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :size, uniqueness: { scope: :product_id }

  def decrement_stock!
    raise "Out of stock" if stock <= 0

    decrement!(:stock)
  end
end
