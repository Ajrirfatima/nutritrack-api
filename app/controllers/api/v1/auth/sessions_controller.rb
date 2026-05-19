module Api
  module V1
    module Auth
      class SessionsController < Devise::SessionsController
        respond_to :json
        skip_before_action :verify_signed_out_user, only: :destroy

        def create
          self.resource = warden.authenticate!(auth_options)
          sign_in(resource_name, resource)
          
          render json: {
            message: "Logged in successfully",
            user: {
              id: resource.id,
              name: resource.name,
              email: resource.email
            }
          }, status: :ok
        end

        def destroy
          if current_user
            sign_out(current_user)
            render json: { message: "Logged out successfully" }, status: :ok
          else
            render json: { message: "Already logged out" }, status: :ok
          end
        end

        private

        def respond_to_on_destroy
          head :no_content
        end
      end
    end
  end
end