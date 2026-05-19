# db/migrate/20240101000001_create_users.rb
class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :encrypted_password, null: false
      t.string :jti, null: false

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :jti, unique: true
  end
end

# db/migrate/20240101000002_create_children.rb
class CreateChildren < ActiveRecord::Migration[7.1]
  def change
    create_table :children do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :age, null: false
      t.string :dietary_restriction, default: "none", null: false
      t.text :notes

      t.timestamps
    end

    add_index :children, [:user_id, :name]
  end
end

# db/migrate/20240101000003_create_food_items.rb
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

# db/migrate/20240101000004_create_meal_plans.rb
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

# db/migrate/20240101000005_create_meal_entries.rb
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
