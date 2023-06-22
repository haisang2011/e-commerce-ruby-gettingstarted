class OrdersController < ApplicationController
  # skip_before_action :verify_authenticity_token
  def index
    orders = Order.all
    render json: { success: true, data: orders }, status: :ok
  end

  def create_test
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

  def create
    cart = Cart.find_by(id: params[:cart_id])
    name_order = "DH" + Time.current.strftime("%Y%m%d%H%M%S")
    total_price = total_price_from_cart(cart)

    if cart
      order = Order.new(name: name_order, user_id: @current_user.id, total_price: total_price)
      if order.save
        begin
          order_details = cart.cart_details.map do |cart_detail|
            {
              order_id: order.id,
              product_id: cart_detail.product_id,
              product_price: cart_detail.product.price,
              quantity: cart_detail.quantity
            }
          end

          OrderDetail.create(order_details)

          data = {
            id: order.id,
            name: order.name,
            status: order.status,
            user_id: order.user_id,
            total_price: order.total_price,
            total_price_formatted: ActionController::Base.helpers.number_with_delimiter(order.total_price, delimiter: ',', separator: '.', unit: '') + ' đ',
            is_deleted: order.is_deleted,
            created_at: order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
            updated_at: order.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
          }

          cart.update(is_deleted: true)
          render json: { success: true, message: "Order created successfully.", data: data }, status: :created
        rescue => e
          order.destroy
          render json: { success: false, message: e.message }, status: :internal_server_error
        end

      else
        render json: { success: false, message: 'Cart not found.' }, status: :not_found
      end
    end
  end

  # def calculator_total_price(products)
  #   products.sum { |item| item[:product_price] * item[:product_quantity] }
  # end
  def total_price_from_cart(cart)
    total_price = 0

    cart.cart_details.each do |cart_detail|
      product_price = cart_detail.product.price
      quantity = cart_detail.quantity
      subtotal = product_price * quantity
      total_price += subtotal
    end

    total_price
  end
  # def subtract_product_quantity(cart)
  #   cart.cart_details.each do |cart_detail|
  #     product = cart_detail.product
  #     new_quantity = product.quantity - cart_detail.quantity
  #     product.update(quantity: new_quantity)
  #   end
  # end
  def get_order_by_user_id
    # orders = Order.where(user_id: @current_user.id, is_deleted: false)
    # data = orders.map do |order|
    #   order.attributes.merge(total_price_formatted: ActionController::Base.helpers.number_with_delimiter(order.total_price, delimiter: ',', separator: '.', unit: '') + ' đ')
    # end
    #
    # render json: {
    #   success: true,
    #   count_order: data.count,
    #   data: data,
    #
    # }, status: :ok
    orders = Order.where(user_id: @current_user.id, is_deleted: false)
    data = orders.map do |order|
      {
        id: order.id,
        name: order.name,
        status: order.status,
        user_id: order.user_id,
        total_price: order.total_price,
        total_price_formatted: ActionController::Base.helpers.number_with_delimiter(order.total_price, delimiter: ',', separator: '.', unit: '') + ' đ',
        is_deleted: order.is_deleted,
        created_at: order.created_at.strftime("%Y-%m-%d %H:%M:%S"),
        updated_at: order.updated_at.strftime("%Y-%m-%d %H:%M:%S"),
      }
    end

    render json: {
      success: true,
      count_order: data.count,
      data: data
    }, status: :ok
  end
end

