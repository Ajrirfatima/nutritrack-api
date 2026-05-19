class CreateFoodItems < ActiveRecord::Migration[7.1]
  def change
    create_table :food_items do |t|
      t.string :name, null: false
      t.decimal :calories, precision: 8, scale: 2, null: false
      t.decimal :protein, precision: 8, scale: 2, default: 0
      t.decimal :carbs, precision: 8, scale: 2, default: 0
      t.decimal :fat, precision: 8, scale: 2, default: 0
      t.string :category, null: false
      t.decimal :serving_size, precision: 8, scale: 2, default: 100
      t.string :serving_unit, null: false, default: "g"

      t.timestamps
    end

    add_index :food_items, :name, unique: true
    add_index :food_items, :category
  end
end