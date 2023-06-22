class AddStatusAndIsDeletedToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :status, :string, default: 'new'
    add_column :orders, :is_deleted, :boolean, default: false
  end
end
