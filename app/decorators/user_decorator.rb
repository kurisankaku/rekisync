class UserDecorator < Draper::Decorator
  delegate_all

  def self.collection_decorator_class
    PaginatingDecorator
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  # Check if are following that user.
  #
  # @return [bool] true: following user, false: unfollow user.
  def is_following?
    return false if context[:following_user_ids].blank?

    context[:following_user_ids].include?(object.id)
  end

  # Return follow or unfollow text by user state.
  #
  # @return [string] follow or unfollow.
  def is_following_text
    return I18n.t("common.follow") if context[:following_user_ids].blank?

    if context[:following_user_ids].include?(object.id)
      I18n.t("common.unfollow")
    else
      I18n.t("common.follow")
    end
  end
end
