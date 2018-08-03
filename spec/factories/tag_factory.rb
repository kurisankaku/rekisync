FactoryBot.define do
  factory :tag do
    id { rand(100_000) }
    name { Faker::Lorem.characters(64) }
  end
end
