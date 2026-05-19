module Api
  module V1
    class MealPlansController < ApplicationController
      before_action :set_child, only: [:index, :create]
      before_action :set_meal_plan, only: [:show, :update, :destroy]

      def index
        meal_plans = @child.meal_plans.recent
        meal_plans = meal_plans.for_date(params[:date]) if params[:date].present?
        meal_plans = meal_plans.this_week if params[:this_week].present?
        meal_plans = meal_plans.page(params[:page]).per(10)

        render json: {
          meal_plans: meal_plans.map { |mp| meal_plan_json(mp) },
          meta: pagination_meta(meal_plans)
        }
      end

      def show
        render json: { meal_plan: meal_plan_json(@meal_plan, detailed: true) }
      end

      def create
        meal_plan = @child.meal_plans.build(meal_plan_params)
        meal_plan.save!
        render json: { meal_plan: meal_plan_json(meal_plan), message: "Meal plan created" }, status: :created
      end

      def update
        @meal_plan.update!(meal_plan_params)
        render json: { meal_plan: meal_plan_json(@meal_plan), message: "Meal plan updated" }
      end

      def destroy
        @meal_plan.destroy!
        render json: { message: "Meal plan deleted" }
      end

      private

      def set_child
        @child = current_user.children.find(params[:child_id])
      end

      def set_meal_plan
        @meal_plan = MealPlan.joins(:child).where(children: { user_id: current_user.id }).find(params[:id])
      end

      def meal_plan_params
        params.require(:meal_plan).permit(:date, :notes)
      end

      def meal_plan_json(meal_plan, detailed: false)
        data = {
          id: meal_plan.id,
          date: meal_plan.date,
          total_calories: meal_plan.total_calories,
          total_protein: meal_plan.total_protein,
          total_carbs: meal_plan.total_carbs,
          calories_remaining: meal_plan.calories_remaining,
          notes: meal_plan.notes
        }
        if detailed
          data[:entries] = meal_plan.meal_entries.includes(:food_item).map do |entry|
            {
              id: entry.id,
              meal_type: entry.meal_type,
              quantity: entry.quantity,
              total_calories: entry.total_calories,
              food_item: {
                id: entry.food_item.id,
                name: entry.food_item.name,
                calories: entry.food_item.calories,
                serving_unit: entry.food_item.serving_unit
              }
            }
          end
        end
        data
      end
    end
  end
end
