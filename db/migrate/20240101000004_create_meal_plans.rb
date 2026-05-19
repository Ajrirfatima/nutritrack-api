class CreateMealPlans < ActiveRecord::Migration[7.1]
  def change
    create_table :meal_plans do |t|
      t.references :child, null: false, foreign_key: true
      t.date :date, null: false
      t.text :notes

      t.timestamps
    end

    add_index :meal_plans, [:child_id, :date], unique: true
  end
end