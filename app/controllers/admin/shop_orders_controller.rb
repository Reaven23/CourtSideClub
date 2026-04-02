class Admin::ShopOrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @orders = Order.includes(:user, order_items: :product).recent

    if params[:payment_status].present?
      @orders = @orders.where(payment_status: params[:payment_status])
    end

    if params[:fulfillment_status].present?
      @orders = @orders.where(fulfillment_status: params[:fulfillment_status])
    end
  end

  def show
    @order = Order.includes(:user, order_items: :product).find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update!(order_params)
    redirect_to admin_shop_order_path(@order), notice: "Commande mise à jour."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Accès refusé." unless current_user.admin?
  end

  def order_params
    params.require(:order).permit(:fulfillment_status)
  end
end
