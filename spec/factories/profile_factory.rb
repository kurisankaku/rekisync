FactoryGirl.define do
  factory :profile do
    id { SecureRandom.hex(64) }
    user { build :user }
    name { Faker::Lorem.characters(10) }
    img_dir_prefix { SecureRandom.hex(2) }
  end
end
