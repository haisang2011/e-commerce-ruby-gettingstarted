class ProductsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    products = Product.where(is_deleted: false)
    render json: { success: true, data: products }, status: :ok
  end

  def create
    begin
      return render json: { success: false, message: "Name is required." }, status: :unprocessable_entity if params[:name].blank?
      return render json: { success: false, message: "Price is required." }, status: :unprocessable_entity if params[:price].blank?

      if Product.exists?(name: params[:name])
        return render json: { success: false, message: "Product with the given name already exists." }, status: :unprocessable_entity
      end

      product = Product.new(product_params)
      product.is_deleted = false

      if product.save
        render json: { success: true, message: product }, status: :ok
      else
        render json: { success: false, message: product.errors }, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false, message: e.message }, status: :internal_server_error
    end
  end

  def update
    begin
      return render json: { success: false, message: "Product ID is required." }, status: :unprocessable_entity if params[:id].blank?

      product = Product.find(params[:id])
      return render json: { success: false, message: "Product ID is required." }, status: :not_found if product.nil?
      return render json: { success: false, message: "Name is required." }, status: :unprocessable_entity if params[:name].blank?
      return render json: { success: false, message: "Price is required."}, status: :unprocessable_entity if params[:price].blank?

      existing_product = Product.find_by(name: params[:name])
      if existing_product && existing_product != product
        return render json: { success: false, message: "Product with the given name already exists."}, status: :unprocessable_entity
      end

      product.name = params[:name]
      product.price = params[:price]
      product.is_deleted = params[:is_deleted].presence || product.is_deleted

      if product.save
        render json: { success: true, message: product}, status: :ok
      else
        render json: { success: true, message: product}, status: :unprocessable_entity
      end
    rescue => e
      render json: { success: false , message: e.message}, status: :internal_server_error
    end
  end

  def destroy
    # return json(false, "Product ID is required.", 422) if params[:id].blank?
    return render json: { success: false, message: "Product ID is required."}, status: :unprocessable_entity if params[:id].blank?
    product = Product.find(params[:id])
    # return json(false, "Product not found.", 404) if product.nil?
    return render json: { success: false, message: "Product not found."}, status: :not_found if product.nil?

    product.update(is_deleted: 1)

    # json(true, "Product removed successfully.", 200)
    render json: { success: true, message: "Product removed successfully."}, status: :ok
  rescue => e
    render json: { success: false, message: e.message}, status: :internal_server_error
  end

  private

  def product_params
    params.permit(:name, :price)
  end
end
