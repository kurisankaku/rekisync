# Users controller.
class UsersController < ApplicationController
  def index
    users = User.includes(:profile).order(:created_at).page(params[:page])
    following_user_ids = self.current_user.followings.where(user_id: users.pluck(:id)).pluck(:user_id)

    @users = users.decorate(context: { following_user_ids: following_user_ids })
  end
end
