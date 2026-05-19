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