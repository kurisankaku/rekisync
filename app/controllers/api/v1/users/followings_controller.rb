module Api
  module V1
    module Users
      # Followings Controller.
      class FollowingsController < ApiApplicationController
        # Get followings list.
        def index
          execute_action do
            user = params[:id].blank? ? self.current_user : UserService.new.find(params[:id])
            render json: user.followings
          end
        end

        # Create a following user.
        def create
          execute_action do
            followed_user = UserService.new.find(params[:id])
            following = FollowService.new.follow_user(self.current_user, followed_user)
            render json: following
          end
        end

        # Destroy a following user.
        def destroy
          execute_action do
            unfollowed_user = UserService.new.find(params[:id])
            FollowService.new.unfollow_user(self.current_user, unfollowed_user)
            head :no_content
          end
        end
      end
    end
  end
end
