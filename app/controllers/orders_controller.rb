class OrdersController < ApplicationController
  # skip_before_action :verify_authenticity_token
  def index
    orders = Order.all
    render json: {success: true, data: orders}, status: :ok
  end
  def create
    return render json: { success: false, message: "Products list is required." }, status: :unprocessable_entity if params[:products].blank?

    begin
      name_order = "DH" + Time.current.strftime("%Y%m%d%H%M%S")
      total_price = calculator_total_price(params[:products])
      order = Order.new(name: name_order, user_id: params[:user_id], total_price: total_price)

      if order.save
        begin
          order_details = params[:products].map do |product|
            {
              order_id: order.id,
              product_id: product[:product_id],
              product_price: product[:product_price],
              quantity: product[:product_quantity]
            }
          end

          OrderDetail.create(order_details)

          render json: { success: true, message: "Order created successfully.", data: order }, status: :ok
        rescue => e
          order.destroy
          render json: { success: false, message: e.message }, status: :internal_server_error
        end
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

