class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def index
    orders = Order.all
    render json: {success: true, data: orders}, status: :ok
  end
  def create
    return render json: { success: false, message: "Products list is required." }, status: :unprocessable_entity if params[:products].blank?
    begin
      name_order = "DH" + Time.current.strftime("%Y%m%d%H%M%S")
      total_price = calculator_total_price(params[:products])
      order = Order.new(name: name_order, user_id: 1, total_price: total_price)

      if order.save
        render json: { success: true, message: "Order created successfully.", data: order }, status: :ok
      else
        render json: { success: false, message: order.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false, message: e.message }, status: :internal_server_error
    end
  end

  def calculator_total_price(products)
    products.sum { |item| item[:product_price] * item[:product_quantity] }
  end
end

