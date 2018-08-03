FactoryBot.define do
  factory :profile do
    id { rand(100_000) }
    user { build :user }
    name { Faker::Lorem.characters(10) }
    img_dir_prefix { SecureRandom.hex(2) }
    birthday_access_scope { AccessScope.first }
  end
end
