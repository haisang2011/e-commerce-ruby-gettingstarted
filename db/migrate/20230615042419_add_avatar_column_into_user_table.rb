class AddAvatarColumnIntoUserTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :avatar, :string, null: true
  end
end
