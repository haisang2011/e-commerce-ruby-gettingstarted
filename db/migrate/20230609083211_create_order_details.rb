class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.bigint "order_id"
      t.bigint "product_id"
      t.integer "product_price"
      t.integer "quantity", default: 1

    end
    add_foreign_key :order_details, :orders, column: :order_id, primary_key: :id
    add_foreign_key :order_details, :products, column: :product_id, primary_key: :id
  end
end
