class ChangeColumnNameTypeInOrders < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :name, :string
  end
end
