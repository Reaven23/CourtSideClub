class Product < ApplicationRecord
  has_many :product_variants, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  has_one_attached :photo

  validates :name, presence: true
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :product_type, presence: true, inclusion: { in: %w[one_time subscription] }

  scope :active, -> { where(active: true) }
  scope :one_time, -> { where(product_type: "one_time") }
  scope :subscriptions, -> { where(product_type: "subscription") }

  def price
    price_cents / 100.0
  end

  def subscription?
    product_type == "subscription"
  end

  def one_time?
    product_type == "one_time"
  end

  def stock_for(size)
    product_variants.find_by(size: size)&.stock || 0
  end

  def total_stock
    product_variants.sum(:stock)
  end

  def in_stock?(size = nil)
    if size
      stock_for(size) > 0
    else
      total_stock > 0
    end
  end

  def available_sizes
    product_variants.where("stock > 0").pluck(:size).compact
  end
end
