class CreateUserRoles < ActiveRecord::Migration[7.0]
  def change
    # Create user_roles table
    create_table(:user_role, primary_key: [:user_id, :role_id]) do |t|
      t.bigint :user_id, null: false
      t.bigint :role_id, null: false
    end

    # Add foreign key for user_flag table
    add_foreign_key :user_role, :users, column: :user_id, primary_key: :id
    add_foreign_key :user_role, :roles, column: :role_id, primary_key: :id
  end
end
