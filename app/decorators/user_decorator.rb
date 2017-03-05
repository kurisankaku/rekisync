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
end
