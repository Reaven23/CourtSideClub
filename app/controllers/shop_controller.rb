class ShopController < ApplicationController
  before_action :authenticate_user!, only: [:create_checkout]

  def index
    @tshirt = Product.active.one_time.first
    @membership = Product.active.subscriptions.first
  end

  def create_checkout
    product = Product.active.find(params[:product_id])
    size = params[:size]

    if product.one_time? && product.product_variants.exists?
      unless product.in_stock?(size)
        redirect_to shop_path, alert: t("shop.errors.out_of_stock")
        return
      end
    end

    session_params = build_checkout_session(product, size)
    checkout_session = Stripe::Checkout::Session.create(session_params)

    redirect_to checkout_session.url, allow_other_host: true, status: :see_other
  end

  def success
    if params[:session_id].present?
      @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    end
  end

  def cancel; end

  private

  def ensure_stripe_customer!
    return if current_user.stripe_customer_id.present?

    customer = Stripe::Customer.create(
      email: current_user.email,
      name: current_user.full_name,
      metadata: { user_id: current_user.id }
    )
    current_user.update!(stripe_customer_id: customer.id)
  end

  def build_checkout_session(product, size)
    ensure_stripe_customer!

    common = {
      customer: current_user.stripe_customer_id,
      success_url: shop_success_url(session_id: "{CHECKOUT_SESSION_ID}"),
      cancel_url: shop_cancel_url,
      metadata: {
        user_id: current_user.id,
        product_id: product.id,
        size: size
      }
    }

    if product.subscription?
      build_subscription_session(product, size, common)
    else
      build_payment_session(product, size, common)
    end
  end

  def build_payment_session(product, size, common)
    common.merge(
      mode: "payment",
      line_items: [{
        price: product.stripe_price_id,
        quantity: 1
      }],
      metadata: common[:metadata].merge(checkout_type: "one_time")
    )
  end

  def build_subscription_session(product, size, common)
    tshirt = Product.active.one_time.first

    common.merge(
      mode: "subscription",
      line_items: [{
        price: product.stripe_price_id,
        quantity: 1
      }],
      metadata: common[:metadata].merge(
        checkout_type: "subscription",
        bundle_tshirt_id: tshirt&.id,
        bundle_tshirt_size: size
      )
    )
  end
end
