module Api
  module V1
    module Users
      # Followers Controller.
      class FollowersController < ApiApplicationController
        # Get followers list.
        def index
          execute_action do
            user = params[:id].blank? ? self.current_user : UserService.new.find(params[:id])
            render json: user.followers
          end
        end
      end
    end
  end
end
