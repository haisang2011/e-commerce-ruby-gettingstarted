class CartController < ApplicationController
  before_action :validate_cart_params, only: [:create]

  def validate_cart_params
    return false unless cart_params[:userId].present? && cart_params[:cartId].present? && cart_params[:dataCart].present?
  end

  def index
    products = Product.where(is_deleted: false)
    products.each do |product|
      product.short_description = product.short_description.truncate(50, omission: '...') if product.short_description
    end
    render json: { success: true, data: products }, status: :ok
  end

  def create
    cart = Cart.find_by(cart_id: cart_params[:cartId]);
    if (!cart.present?)
      cart = Cart.create()
    end
  end

  private
  def cart_params
    params.permit(:userId, :cartId, :dataCart)
  end
end
