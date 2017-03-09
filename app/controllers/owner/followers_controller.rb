module Owner
  class FollowersController < ApplicationController
    def index
      begin
        user = UserService.new.find_by_name(params[:name])
        followers = user.followers.order("created_at desc").page(params[:page])
        following_user_ids = self.current_user.followings.where(user_id: followers.pluck(:owner_id)).pluck(:user_id)
        @follows = followers.decorate(context: { following_user_ids: following_user_ids })
      rescue BadRequestError => e
        logger.error build_log(e, e.status_code).to_json
        raise NotFoundPageError
      end
    end
  end
end
