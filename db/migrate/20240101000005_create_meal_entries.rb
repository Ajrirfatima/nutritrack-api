class CreateMealEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_entries do |t|
      t.references :meal_plan, null: false, foreign_key: true
      t.references :food_item, null: false, foreign_key: true
      t.string :meal_type, null: false
      t.decimal :quantity, precision: 8, scale: 2, null: false, default: 1

      t.timestamps
    end

    add_index :meal_entries, [:meal_plan_id, :food_item_id, :meal_type]
  end
end