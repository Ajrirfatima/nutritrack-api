module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          render json: {
            message: "Logged in successfully",
            user: {
              id: resource.id,
              name: resource.name,
              email: resource.email
            }
          }, status: :ok
        end

        def respond_to_on_destroy
          render json: { message: "Logged out successfully" }, status: :ok
        end
      end

      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        private

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: {
              message: "Account created successfully",
              user: {
                id: resource.id,
                name: resource.name,
                email: resource.email
              }
            }, status: :created
          else
            render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
