# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_06_07_084822) do
  create_table "flags", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "role_flag", primary_key: ["role_id", "flag_id"], charset: "utf8mb3", force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "flag_id", null: false
    t.index ["flag_id"], name: "fk_rails_933f4f7faa"
  end

  create_table "roles", charset: "utf8mb3", force: :cascade do |t|
    t.string "name", null: false
  end

  create_table "user_role", primary_key: ["user_id", "role_id"], charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
    t.index ["role_id"], name: "fk_rails_9e161aeb5c"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", null: false
    t.string "password", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "middle_name"
    t.integer "age"
    t.integer "gender", default: 0, null: false
    t.timestamp "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.timestamp "updated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  add_foreign_key "role_flag", "flags"
  add_foreign_key "role_flag", "roles"
  add_foreign_key "user_role", "roles"
  add_foreign_key "user_role", "users"
end
