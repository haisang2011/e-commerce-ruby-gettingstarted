class CreateCartDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :cart_details do |t|
      t.bigint "cart_id"
      t.bigint "product_id"
      t.integer "quantity", default: 1
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
    add_foreign_key :cart_details, :products, column: :product_id, primary_key: :id
    add_foreign_key :cart_details, :carts, column: :cart_id, primary_key: :id
  end
end