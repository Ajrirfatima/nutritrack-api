class Child < ApplicationRecord
  belongs_to :user
  has_many :meal_plans, dependent: :destroy

  DIETARY_RESTRICTIONS = %w[none vegetarian vegan gluten_free dairy_free nut_free halal].freeze

  validates :name, presence: true
  validates :age, presence: true,
                  numericality: { only_integer: true, greater_than: 0, less_than: 18 }
  validates :dietary_restriction, inclusion: { in: DIETARY_RESTRICTIONS }

  scope :by_age, ->(age) { where(age: age) }
  scope :with_restriction, ->(restriction) { where(dietary_restriction: restriction) }

  def daily_calorie_goal
    # Basic estimated daily calorie needs by age
    case age
    when 1..3  then 1200
    when 4..8  then 1500
    when 9..13 then 1800
    else 2000
    end
  end
end
