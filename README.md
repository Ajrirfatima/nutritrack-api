# NutriTrack API

A RESTful API built with Ruby on Rails for managing children's nutrition and meal plans. Designed for childcare facilities, nutritionists, and parents to track daily food intake and ensure healthy eating habits.

## Features

- **JWT Authentication** — secure token-based auth via Devise + devise-jwt
- **Children Profiles** — manage profiles with age-based calorie goals and dietary restrictions
- **Meal Plans** — daily meal planning with automatic nutrition calculation
- **Food Item Database** — searchable food database with full macronutrient tracking
- **Nutrition Summary** — real-time calorie and macro totals per meal plan
- **Pagination** — all list endpoints paginated with metadata
- **Scoped Access** — users can only access their own children's data

## Tech Stack

- **Ruby on Rails 7.2** — API mode
- **PostgreSQL** — primary database
- **Devise + devise-jwt** — authentication
- **RSpec** — testing
- **FactoryBot + Faker** — test data

## Getting Started

### Requirements

- Ruby 3.1+
- PostgreSQL 15+
- Bundler

### Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/nutritrack-api.git
cd nutritrack-api

# Install dependencies
bundle install

# Configure environment variables
cp .env.example .env
# Edit .env with your database credentials and JWT secret

# Setup database
rails db:create db:migrate db:seed

# Run the server
rails s
```

### Environment Variables

```
DB_USERNAME=your_db_user
DB_PASSWORD=your_db_password
DB_HOST=localhost
JWT_SECRET_KEY=your_secret_key
```

## API Endpoints

### Authentication

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register a new user |
| POST | `/api/v1/auth/login` | Login and receive JWT token |
| DELETE | `/api/v1/auth/logout` | Logout and invalidate token |

### Children

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/children` | List all children |
| POST | `/api/v1/children` | Create a child profile |
| GET | `/api/v1/children/:id` | Get a child profile |
| PATCH | `/api/v1/children/:id` | Update a child profile |
| DELETE | `/api/v1/children/:id` | Delete a child profile |

**Query params:** `?age=5`, `?dietary_restriction=vegan`, `?page=1`

### Meal Plans

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/children/:child_id/meal_plans` | List meal plans for a child |
| POST | `/api/v1/children/:child_id/meal_plans` | Create a meal plan |
| GET | `/api/v1/meal_plans/:id` | Get meal plan with nutrition summary |
| PATCH | `/api/v1/meal_plans/:id` | Update a meal plan |
| DELETE | `/api/v1/meal_plans/:id` | Delete a meal plan |

**Query params:** `?date=2024-01-15`, `?this_week=true`

### Food Items

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | `/api/v1/food_items` | List/search food items |
| POST | `/api/v1/food_items` | Add a food item |
| GET | `/api/v1/food_items/:id` | Get a food item |
| PATCH | `/api/v1/food_items/:id` | Update a food item |
| DELETE | `/api/v1/food_items/:id` | Delete a food item |

**Query params:** `?query=apple`, `?category=fruit`, `?low_calorie=true`

## Example Requests

### Register
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"user": {"name": "Fatima", "email": "fatima@example.com", "password": "password123"}}'
```

### Create a Child Profile
```bash
curl -X POST http://localhost:3000/api/v1/children \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"child": {"name": "Sara", "age": 5, "dietary_restriction": "none"}}'
```

### Get Meal Plan with Nutrition Summary
```bash
curl http://localhost:3000/api/v1/meal_plans/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

Response:
```json
{
  "meal_plan": {
    "id": 1,
    "date": "2024-01-15",
    "total_calories": 1320.5,
    "total_protein": 45.2,
    "total_carbs": 180.3,
    "calories_remaining": 179.5,
    "entries": [
      {
        "meal_type": "breakfast",
        "quantity": 1.5,
        "total_calories": 210.0,
        "food_item": {
          "name": "Oatmeal",
          "calories": 140,
          "serving_unit": "g"
        }
      }
    ]
  }
}
```

## Running Tests

```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/child_spec.rb
bundle exec rspec spec/requests/children_spec.rb

# With coverage report
COVERAGE=true bundle exec rspec
```

## Data Models

```
User
 └── has_many Children
      └── has_many MealPlans
           └── has_many MealEntries
                └── belongs_to FoodItem
```

### Dietary Restrictions Supported
`none` · `vegetarian` · `vegan` · `gluten_free` · `dairy_free` · `nut_free` · `halal`

### Meal Types
`breakfast` · `lunch` · `dinner` · `snack`

### Food Categories
`fruit` · `vegetable` · `grain` · `protein` · `dairy` · `fat` · `beverage` · `other`

## Design Decisions

- **API-only Rails** — no frontend, clean separation of concerns
- **JWT over sessions** — stateless auth suitable for mobile and web clients
- **Scoped queries** — all data access goes through `current_user` to prevent unauthorized access
- **Shallow routes** — meal plans and entries accessible without always nesting under children
- **Calorie goals by age** — based on standard nutritional guidelines for children

## Author

Fatima Ajrir — Full-Stack Developer (Ruby on Rails)
[GitHub](https://github.com/yourusername) · [LinkedIn](https://linkedin.com/in/yourprofile)
