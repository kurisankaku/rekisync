class FollowingDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :owner, with: UserDecorator

  def self.collection_decorator_class
    PaginatingDecorator
  end
end
