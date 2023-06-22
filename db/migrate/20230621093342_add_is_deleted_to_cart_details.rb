class AddIsDeletedToCartDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_details, :is_deleted, :boolean
  end
end
