FactoryGirl.define do
  factory :profile do
    id { rand(100_000_000_000) }
    user { build :user }
    name { Faker::Lorem.characters(10) }
    img_dir_prefix { SecureRandom.hex(2) }
  end
end
