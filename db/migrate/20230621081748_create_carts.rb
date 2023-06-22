class CreateCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :carts do |t|
      t.bigint "user_id"
      t.boolean "is_deleted"
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
    add_foreign_key :carts, :users, column: :user_id, primary_key: :id
  end
end