# Third party access token model.
class ThirdPartyAccessToken < ApplicationRecord
  belongs_to :user
  validates :uid, presence: true
  validates :provider,
            presence: true,
            length: { maximum: 32 }
  validates :token, presence: true
  validates :user, presence: true
end
