class AddDefaultToIsDeletedForCartDetails < ActiveRecord::Migration[7.0]
  def change
    change_column_default :cart_details, :is_deleted, from: nil, to: 0
  end
end
