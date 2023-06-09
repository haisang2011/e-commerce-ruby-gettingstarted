class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :email, null: false, unique: true
      t.string :password, null: false
      t.string :first_name, null: true
      t.string :last_name, null: true
      t.string :middle_name, null: true
      t.integer :age, null: true
      t.integer :gender, null: false, default: 0
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
    end
  end
end
