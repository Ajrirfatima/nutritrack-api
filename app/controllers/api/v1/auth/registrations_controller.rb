module Api
  module V1
    module Auth
      class RegistrationsController < Devise::RegistrationsController
        respond_to :json

        def create
          build_resource(sign_up_params)
          
          if resource.save
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

        private

        def sign_up_params
          params.require(:user).permit(:email, :password, :password_confirmation, :name)
        end

        def respond_with(resource, _opts = {})
          # Handled in create method
        end
      end
    end
  end
end