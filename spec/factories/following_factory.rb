FactoryBot.define do
  factory :following do
    id { rand(100_000) }
    owner { build :user }
    user { build :user }
  end
end
