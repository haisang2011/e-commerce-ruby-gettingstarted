class CreateFlags < ActiveRecord::Migration[7.0]
  def change
    create_table :flags do |t|
      t.string :name, unique: true, null: false
    end
  end
end
