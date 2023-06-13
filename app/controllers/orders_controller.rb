class OrdersController < ApplicationController
  include JsonResponse

  skip_before_action :verify_authenticity_token

  def create
    # total_price_for_all_product(params["products"])
    total_price = 0
    params["products"].each do |product|
      prod_query = Product.find_by(id: product[:product_id])
      subtotal = product[:product_price] * product[:quantity]
      total_price += subtotal
    end
    puts "Total price: #{total_price}"
  end

  def total_price_for_all_product(prod_item)
    prod_item.each do |prod|
      # total_price = 0
      # per_product = Product.where(id: prod["product_id"])
      per_product = Product.find(prod["product_id"])
      # quantity = prod["quantity"]
      # puts "Product ID: #{product_id}, Quantity: #{quantity}, Price: #{product}"
      json(true, per_product, 200)
    end
  end
end
