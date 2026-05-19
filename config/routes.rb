Rails.application.routes.draw do
  devise_for :users,
    path: "",
    path_names: {
      sign_in: "api/v1/auth/login",
      sign_out: "api/v1/auth/logout",
      registration: "api/v1/auth/register"
    },
    controllers: {
      sessions: "api/v1/auth/sessions",
      registrations: "api/v1/auth/registrations"
    }

  namespace :api do
    namespace :v1 do
      resources :children do
        resources :meal_plans, shallow: true do
          resources :meal_entries, shallow: true
        end
      end
      resources :food_items, only: [:index, :show, :create, :update, :destroy]
    end
  end

  get "up", to: proc { [200, {}, ["OK"]] }
end
