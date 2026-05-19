class MealPlan < ApplicationRecord
  belongs_to :child
  has_many :meal_entries, dependent: :destroy

  validates :date, presence: true, uniqueness: { scope: :child_id,
    message: "already has a meal plan for this date" }
  validates :notes, length: { maximum: 500 }

  scope :for_date, ->(date) { where(date: date) }
  scope :recent, -> { order(date: :desc) }
  scope :this_week, -> { where(date: Date.current.beginning_of_week..Date.current.end_of_week) }

  def total_calories
    meal_entries.joins(:food_item).sum("food_items.calories * meal_entries.quantity")
  end

  def total_protein
    meal_entries.joins(:food_item).sum("food_items.protein * meal_entries.quantity")
  end

  def total_carbs
    meal_entries.joins(:food_item).sum("food_items.carbs * meal_entries.quantity")
  end

  def calories_remaining
    child.daily_calorie_goal - total_calories
  end
end
