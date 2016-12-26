FactoryGirl.define do
  factory :third_party_access_token do
    id { SecureRandom.hex(64) }
    token { SecureRandom.hex(64) }
    provider { Faker::Lorem.characters(32) }
    uid { SecureRandom.hex(64) }
    user { build :user }
  end
end
