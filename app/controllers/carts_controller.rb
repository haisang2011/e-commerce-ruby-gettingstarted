class CartsController < ApplicationController
  def show
    cart = Cart.find_by(user_id: @current_user.id, is_deleted: false)

    if cart
      cart_details = cart.cart_details.where(is_deleted: 0)

      response_data = {
        success: true,
        message: 'Cart details retrieved successfully.',
        data: {
          cart_id: cart.id,
          user_id: @current_user.id,
          cart_details: cart_details.map do |detail|
            {
              product_id: detail.product.id,
              product_name: detail.product.name,
              product_image_url: detail.product.image_url,
              quantity: detail.quantity
            }
          end
        }
      }

      render json: response_data, status: :ok
    else
      render json: { success: false, message: 'Cart not found.' }, status: :not_found
    end
  end
  def add_to_cart
    begin
      # Find or create a cart associated with the current user and not marked as deleted
      cart = Cart.find_or_create_by(user_id: @current_user.id, is_deleted: false)

      # Find the product based on the provided product_id parameter
      product = Product.find_by(id: params[:product_id])

      # Find the cart detail associated with the cart and product that is not marked as deleted
      cart_detail = CartDetail.where(cart_id: cart.id, product_id: product.id, is_deleted: 0).first

      # Determine the quantity of the product to be added to the cart
      product_quantity = params[:product_quantity].presence&.to_i || 1

      if cart_detail
        # If the cart detail exists, update the quantity by adding the product_quantity
        cart_detail.quantity += product_quantity
      else
        # If the cart detail does not exist, create a new cart detail with the provided information
        cart_detail = CartDetail.new(cart_id: cart.id, product_id: product.id, quantity: product_quantity)
      end

      # if cart_detail.save
      #   response_data = {
      #     success: true,
      #     message: 'Product added to cart successfully.',
      #     data: {
      #       cart_id: cart.id,
      #       user_id: @current_user.id,
      #       cart_details: cart.cart_details.map do |detail|
      #         {
      #           product_id: detail.product.id,
      #           product_name: detail.product.name,
      #           total_quantity: detail.quantity
      #         }
      #       end
      #     }
      #   }
      #
      #   render json: response_data, status: :ok
      # else
      #   render json: { success: false, message: 'Failed to add product to cart.' }, status: :unprocessable_entity
      # end

      if cart_detail.save
        render json: { success: true, message: 'Product added to cart successfully.',data: {
          cart_id: cart.id,
          user_id: @current_user.id,
          product_id: product.id,
          product_name: product.name,
          total_quantity: cart_detail.quantity
        } }, status: :ok
      else
        render json: { success: false, message: 'Failed to add product to cart.' }, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      # Find the cart associated with the current user and not marked as deleted
      cart = Cart.find_by(user_id: @current_user.id, is_deleted: false)

      # Find the product based on the provided product_id parameter
      product = Product.find_by(id: params[:product_id])

      if cart && product
        # Find the cart detail associated with the cart and product
        cart_detail = cart.cart_details.find_by(product_id: product.id)

        if cart_detail
          # Mark the cart detail as deleted
          cart_detail.update(is_deleted: 1)
          render json: { success: true, message: 'Product removed from cart successfully.', data: {
            cart_id: cart.id,
            user_id: @current_user.id,
            product_id: product.id,
            product_name: product.name,
            total_quantity: cart_detail.quantity
          } }, status: :ok
        else
          # If cart detail is not found, return a JSON response indicating the product was not found in the cart
          render json: { success: false, message: 'Product not found in cart.' }, status: :not_found
        end
      else
        # If cart or product is not found, return a JSON response indicating cart or product not found
        render json: { success: false, message: 'Cart or product not found.' }, status: :not_found
      end
    rescue => e
      # If any error occurs during the process, return a JSON response with the error message
      render json: { success: false, message: e.message }, status: :unprocessable_entity
    end
  end

  def clear_cart
    # Find the cart associated with the current user and not marked as deleted
    cart = Cart.find_by(user_id: @current_user.id, is_deleted: false)

    if cart
      # Delete all cart details associated with the cart
      cart.cart_details.each do |cart_detail|
        cart_detail.update(is_deleted: true)
      end

      # Update the is_deleted attribute of the cart to mark it as deleted
      cart.update(is_deleted: true)

      render json: { success: true, message: 'Cart cleared successfully.' }, status: :ok
    else
      # If no cart is found, return a JSON response indicating the cart was not found
      render json: { success: false, message: 'Cart not found.' }, status: :not_found
    end
  end
end
