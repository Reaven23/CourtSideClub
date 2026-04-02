class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  skip_before_action :set_locale

  def stripe
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, ENV["STRIPE_WEBHOOK_SECRET"]
      )
    rescue JSON::ParserError
      head :bad_request
      return
    rescue Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    case event.type
    when "checkout.session.completed"
      handle_checkout_completed(event.data.object)
    when "customer.subscription.updated"
      handle_subscription_updated(event.data.object)
    when "customer.subscription.deleted"
      handle_subscription_deleted(event.data.object)
    end

    head :ok
  end

  private

  def handle_checkout_completed(session)
    user = User.find_by(id: session.metadata.user_id)
    return unless user

    product = Product.find_by(id: session.metadata.product_id)
    return unless product

    order = Order.create!(
      user: user,
      stripe_checkout_session_id: session.id,
      stripe_payment_intent_id: session.payment_intent,
      stripe_subscription_id: session.subscription,
      payment_status: "paid",
      fulfillment_status: "pending",
      total_cents: session.amount_total
    )

    order.order_items.create!(
      product: product,
      quantity: 1,
      unit_price_cents: product.price_cents,
      size: session.metadata.size
    )

    if product.one_time?
      decrement_stock(product, session.metadata.size)
    end

    if session.metadata.checkout_type == "subscription"
      handle_subscription_order(user, order, session)
    end
  end

  def handle_subscription_order(user, order, session)
    user.update!(
      subscription_status: "active",
      subscription_end_date: 1.year.from_now
    )

    tshirt = Product.find_by(id: session.metadata.bundle_tshirt_id)
    return unless tshirt

    order.order_items.create!(
      product: tshirt,
      quantity: 1,
      unit_price_cents: 0,
      size: session.metadata.bundle_tshirt_size,
      bundle_free: true
    )

    decrement_stock(tshirt, session.metadata.bundle_tshirt_size)
  end

  def handle_subscription_updated(subscription)
    user = User.find_by(stripe_customer_id: subscription.customer)
    return unless user

    status = case subscription.status
             when "active" then "active"
             when "past_due" then "past_due"
             when "canceled" then "canceled"
             else subscription.status
             end

    user.update!(
      subscription_status: status,
      subscription_end_date: Time.at(subscription.current_period_end)
    )
  end

  def handle_subscription_deleted(subscription)
    user = User.find_by(stripe_customer_id: subscription.customer)
    return unless user

    user.update!(
      subscription_status: "canceled",
      subscription_end_date: Time.at(subscription.current_period_end)
    )
  end

  def decrement_stock(product, size)
    variant = product.product_variants.find_by(size: size)
    variant&.decrement_stock! if variant&.stock&.positive?
  rescue StandardError => e
    Rails.logger.error("Stock decrement failed: #{e.message}")
  end
end
