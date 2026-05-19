FactoryBot.define do
  factory :user do
    name { Faker::Name.full_name }
    email { Faker::Internet.unique.email }
    password { "password123" }
    password_confirmation { "password123" }
  end

  factory :child do
    association :user
    name { Faker::Name.first_name }
    age { rand(1..17) }
    dietary_restriction { Child::DIETARY_RESTRICTIONS.sample }
    notes { Faker::Lorem.sentence }
  end

  factory :food_item do
    name { Faker::Food.ingredient }
    calories { rand(10..500) }
    protein { rand(0.0..50.0).round(1) }
    carbs { rand(0.0..80.0).round(1) }
    fat { rand(0.0..30.0).round(1) }
    category { FoodItem::CATEGORIES.sample }
    serving_size { 100 }
    serving_unit { "g" }
  end

  factory :meal_plan do
    association :child
    date { Date.current }
    notes { Faker::Lorem.sentence }
  end

  factory :meal_entry do
    association :meal_plan
    association :food_item
    meal_type { MealEntry::MEAL_TYPES.sample }
    quantity { rand(0.5..3.0).round(1) }
  end
end
