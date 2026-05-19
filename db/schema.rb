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

ActiveRecord::Schema[7.2].define(version: 2026_05_19_151122) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "children", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "age", null: false
    t.string "dietary_restriction", default: "none", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_children_on_user_id_and_name"
    t.index ["user_id"], name: "index_children_on_user_id"
  end

  create_table "food_items", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "calories", precision: 8, scale: 2, null: false
    t.decimal "protein", precision: 8, scale: 2, default: "0.0"
    t.decimal "carbs", precision: 8, scale: 2, default: "0.0"
    t.decimal "fat", precision: 8, scale: 2, default: "0.0"
    t.string "category", null: false
    t.decimal "serving_size", precision: 8, scale: 2, default: "100.0"
    t.string "serving_unit", default: "g", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_food_items_on_category"
    t.index ["name"], name: "index_food_items_on_name", unique: true
  end

  create_table "jwt_denylists", force: :cascade do |t|
    t.string "jti"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_jwt_denylists_on_jti"
  end

  create_table "meal_entries", force: :cascade do |t|
    t.bigint "meal_plan_id", null: false
    t.bigint "food_item_id", null: false
    t.string "meal_type", null: false
    t.decimal "quantity", precision: 8, scale: 2, default: "1.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_item_id"], name: "index_meal_entries_on_food_item_id"
    t.index ["meal_plan_id", "food_item_id", "meal_type"], name: "idx_on_meal_plan_id_food_item_id_meal_type_84c5605fd9"
    t.index ["meal_plan_id"], name: "index_meal_entries_on_meal_plan_id"
  end

  create_table "meal_plans", force: :cascade do |t|
    t.bigint "child_id", null: false
    t.date "date", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["child_id", "date"], name: "index_meal_plans_on_child_id_and_date", unique: true
    t.index ["child_id"], name: "index_meal_plans_on_child_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "encrypted_password", null: false
    t.string "jti", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
  end

  add_foreign_key "children", "users"
  add_foreign_key "meal_entries", "food_items"
  add_foreign_key "meal_entries", "meal_plans"
  add_foreign_key "meal_plans", "children"
end
