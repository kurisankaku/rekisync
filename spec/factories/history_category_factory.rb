FactoryBot.define do
  factory :history_category do
    id { rand(1_000) }
    name { Faker::Lorem.characters(10) }
  end
end
