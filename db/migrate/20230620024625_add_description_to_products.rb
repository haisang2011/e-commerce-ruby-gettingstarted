class AddDescriptionToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :description, :text
    add_column :products, :short_description, :string, limit: 512
  end
end
