class CreateRoleFlags < ActiveRecord::Migration[7.0]
  def change
    
    # Create role_flag table
    create_table(:role_flag, primary_key: [:role_id, :flag_id]) do |t|
      t.bigint :role_id, null: false
      t.bigint :flag_id, null: false
    end

    # Add foreign key for role_flag table
    add_foreign_key :role_flag, :roles, column: :role_id, primary_key: :id
    add_foreign_key :role_flag, :flags, column: :flag_id, primary_key: :id
  end
end
