module Owner
  class FollowingsController < ApplicationController
    def index
      begin
        user = UserService.new.find_by_name(params[:name])
        followings = user.followings.order("created_at desc").page(params[:page])
        following_user_ids = self.current_user.followings.where(user_id: followings.pluck(:user_id)).pluck(:user_id)
        @follows = followings.decorate(context: { following_user_ids: following_user_ids })
      rescue BadRequestError => e
        logger.error build_log(e, e.status_code).to_json
        raise NotFoundPageError
      end
    end
  end
end
