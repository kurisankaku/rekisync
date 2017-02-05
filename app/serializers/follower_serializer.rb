# Follower Serializer.
class FollowerSerializer < ActiveModel::Serializer
  attributes :id
  belongs_to :owner, key: :user

  class UserSerializer < ActiveModel::Serializer
    attribute :name, key: :user_name
    has_one :profile

    class ProfileSerializer < ActiveModel::Serializer
      attribute :name
      attribute :avator_image_url
        object.avator_image.try(:url)
      attribute :background_image_url do
        object.background_image.try(:url)
      end
      attribute :about_me do
        object.about_me.truncate(20) if object.about_me.present?
      end
    end
  end
end
