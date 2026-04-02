class Admin::ShopProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  def index
    @products = Product.includes(:product_variants).order(:created_at)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      if @product.one_time? && params[:sizes].present?
        params[:sizes].each do |size, stock|
          @product.product_variants.create!(size: size, stock: stock.to_i) if stock.to_i >= 0
        end
      end
      redirect_to admin_shop_products_path, notice: "Produit créé."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product = Product.includes(:product_variants).find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if params[:product_variants].present?
      params[:product_variants].each do |variant_id, variant_params|
        variant = @product.product_variants.find(variant_id)
        variant.update!(stock: variant_params[:stock])
      end
    end

    @product.update!(product_params)
    redirect_to admin_shop_products_path, notice: "Produit mis à jour."
  end

  private

  def ensure_admin!
    redirect_to root_path, alert: "Accès refusé." unless current_user.admin?
  end

  def product_params
    params.require(:product).permit(:name, :description, :price_cents, :product_type, :active, :stripe_price_id, :stripe_product_id)
  end
end
