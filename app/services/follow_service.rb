# Follow Service
class FollowService
  # Follow a user.
  #
  # @param [User] owner the user who follow the user.
  # @param [User] followed_user the user who is followed by owner.
  # @return [Following] following.
  def follow_user(owner, followed_user)
    following = owner.followings.with_deleted.find_by(user: followed_user)
    if following.present?
      following.restore if following.deleted?
      following
    else
      owner.followings.create! do |o|
        o.user = followed_user
      end
    end
  end

  # Unfollow a user.
  #
  # @param [User] owner the user who unfollow the user.
  # @param [User] unfollowed_user the user who is unfollowed by owner.
  def unfollow_user(owner, unfollowed_user)
    following = owner.followings.find_by(user: unfollowed_user)
    if following.nil?
      fail BadRequestError.new(code: :not_followed_user, field: :user), "Not followed user"
    end
    following.destroy
  end
end
