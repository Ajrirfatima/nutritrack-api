Rails.application.routes.draw do
  devise_for :users,
    path: "api/v1/auth",
    path_names: {
      sign_in: "login",
      sign_out: "logout",
      registration: "register"
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