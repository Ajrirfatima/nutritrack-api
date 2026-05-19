class MealEntry < ApplicationRecord
  
  include Devise::JWT::RevocationStrategies::Denylist

  belongs_to :meal_plan
  belongs_to :food_item

  MEAL_TYPES = %w[breakfast lunch dinner snack].freeze

  validates :meal_type, presence: true, inclusion: { in: MEAL_TYPES }
  validates :quantity, presence: true,
                       numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  scope :by_meal_type, ->(type) { where(meal_type: type) }

  def total_calories
    food_item.calories * quantity
  end
end
