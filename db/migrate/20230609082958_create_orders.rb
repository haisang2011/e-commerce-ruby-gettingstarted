class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer "name"
      t.bigint "user_id"
      t.integer "total_price"
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
    add_foreign_key :orders, :users, column: :user_id, primary_key: :id
  end
end
