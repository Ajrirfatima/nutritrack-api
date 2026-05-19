module Api
  module V1
    class ChildrenController < ApplicationController
      before_action :set_child, only: [:show, :update, :destroy]

      def index
        children = current_user.children
        children = children.by_age(params[:age]) if params[:age].present?
        children = children.with_restriction(params[:dietary_restriction]) if params[:dietary_restriction].present?
        children = children.page(params[:page]).per(params[:per_page] || 10)

        render json: {
          children: children.map { |c| child_json(c) },
          meta: pagination_meta(children)
        }
      end

      def show
        render json: { child: child_json(@child, detailed: true) }
      end

      def create
        child = current_user.children.build(child_params)
        child.save!
        render json: { child: child_json(child), message: "Child added successfully" }, status: :created
      end

      def update
        @child.update!(child_params)
        render json: { child: child_json(@child), message: "Child updated successfully" }
      end

      def destroy
        @child.destroy!
        render json: { message: "Child removed successfully" }
      end

      private

      def set_child
        @child = current_user.children.find(params[:id])
      end

      def child_params
        params.require(:child).permit(:name, :age, :dietary_restriction, :notes)
      end

      def child_json(child, detailed: false)
        data = {
          id: child.id,
          name: child.name,
          age: child.age,
          dietary_restriction: child.dietary_restriction,
          daily_calorie_goal: child.daily_calorie_goal,
          created_at: child.created_at
        }
        data[:notes] = child.notes if detailed
        data[:meal_plans_count] = child.meal_plans.count if detailed
        data
      end
    end
  end
end
