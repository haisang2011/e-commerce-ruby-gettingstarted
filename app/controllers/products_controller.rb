class ProductsController < ApplicationController
  include JsonResponse
  skip_before_action :verify_authenticity_token

  def index
    products = Product.where(is_deleted: false)
    json(true, products, 200)
  end

  def create
    begin
      return json(false, "Name is required.", 422) if params[:name].blank?
      return json(false, "Price is required.", 422) if params[:price].blank?

      if Product.exists?(name: params[:name])
        return json(false, "Product with the given name already exists.", 422)
      end

      product = Product.new(product_params)
      product.is_deleted = false

      if product.save
        json(true, product, 200)
      else
        json(false, product.errors, 422)
      end
    rescue => e
      json(false, e.message, 500)
    end
  end

  def update
    begin
      return json(false, "Product ID is required.", 422) if params[:id].blank?

      product = Product.find(params[:id])
      return json(false, "Product not found.", 404) if product.nil?

      return json(false, "Name is required.", 422) if params[:name].blank?
      return json(false, "Price is required.", 422) if params[:price].blank?

      existing_product = Product.find_by(name: params[:name])
      if existing_product && existing_product != product
        return json(false, "Product with the given name already exists.", 422)
      end

      product.name = params[:name]
      product.price = params[:price]
      product.is_deleted = params[:is_deleted].presence || product.is_deleted

      if product.save
        json(true, product, 200)
      else
        json(false, product.errors, 422)
      end
    rescue => e
      json(false, e.message, 500)
    end
  end

  def destroy
    return json(false, "Product ID is required.", 422) if params[:id].blank?

    product = Product.find(params[:id])
    return json(false, "Product not found.", 404) if product.nil?

    product.update(is_deleted: 1)

    json(true, "Product removed successfully.", 200)
  rescue => e
    json(false, e.message, 500)
  end

  private

  def product_params
    params.permit(:name, :price)
  end
end
