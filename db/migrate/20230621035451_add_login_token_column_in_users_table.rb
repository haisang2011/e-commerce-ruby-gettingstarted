class AddLoginTokenColumnInUsersTable < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :login_token, :string, limit: 512
  end
end
