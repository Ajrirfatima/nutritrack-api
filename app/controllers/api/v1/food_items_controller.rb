module Api
  module V1
    class FoodItemsController < ApplicationController
      before_action :set_food_item, only: [:show, :update, :destroy]

      def index
        food_items = FoodItem.all
        food_items = food_items.search(params[:query]) if params[:query].present?
        food_items = food_items.by_category(params[:category]) if params[:category].present?
        food_items = food_items.low_calorie if params[:low_calorie].present?
        food_items = food_items.order(:name).page(params[:page]).per(20)

        render json: {
          food_items: food_items.map { |f| food_item_json(f) },
          meta: pagination_meta(food_items)
        }
      end

      def show
        render json: { food_item: food_item_json(@food_item) }
      end

      def create
        food_item = FoodItem.new(food_item_params)
        food_item.save!
        render json: { food_item: food_item_json(food_item), message: "Food item created" }, status: :created
      end

      def update
        @food_item.update!(food_item_params)
        render json: { food_item: food_item_json(@food_item), message: "Food item updated" }
      end

      def destroy
        @food_item.destroy!
        render json: { message: "Food item deleted" }
      end

      private

      def set_food_item
        @food_item = FoodItem.find(params[:id])
      end

      def food_item_params
        params.require(:food_item).permit(:name, :calories, :protein, :carbs, :fat, :category, :serving_unit, :serving_size)
      end

      def food_item_json(food_item)
        {
          id: food_item.id,
          name: food_item.name,
          calories: food_item.calories,
          protein: food_item.protein,
          carbs: food_item.carbs,
          fat: food_item.fat,
          category: food_item.category,
          serving_size: food_item.serving_size,
          serving_unit: food_item.serving_unit
        }
      end
    end
  end
end
