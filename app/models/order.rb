class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :total_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :payment_status, inclusion: { in: %w[pending paid failed refunded] }
  validates :fulfillment_status, inclusion: { in: %w[pending processing shipped delivered] }

  scope :paid, -> { where(payment_status: "paid") }
  scope :recent, -> { order(created_at: :desc) }

  PAYMENT_STATUSES = %w[pending paid failed refunded].freeze
  FULFILLMENT_STATUSES = %w[pending processing shipped delivered].freeze

  def total
    total_cents / 100.0
  end

  def paid?
    payment_status == "paid"
  end

  def includes_subscription?
    order_items.joins(:product).where(products: { product_type: "subscription" }).exists?
  end

  def includes_tshirt?
    order_items.joins(:product).where(products: { product_type: "one_time" }).exists?
  end
end
