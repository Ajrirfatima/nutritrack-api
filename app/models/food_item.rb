class FoodItem < ApplicationRecord
  has_many :meal_entries, dependent: :restrict_with_error

  CATEGORIES = %w[fruit vegetable grain protein dairy fat beverage other].freeze

  validates :name, presence: true, uniqueness: { case_insensitive: true }
  validates :calories, presence: true,
                       numericality: { greater_than_or_equal_to: 0 }
  validates :protein, :carbs, :fat,
            numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :serving_unit, presence: true

  scope :by_category, ->(category) { where(category: category) }
  scope :search, ->(query) { where("name ILIKE ?", "%#{sanitize_sql_like(query)}%") }
  scope :low_calorie, -> { where("calories < 100") }
end
