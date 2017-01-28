FactoryGirl.define do
  factory :following do
    id { rand(100_000_000_000) }
    owner { build :user }
    user { build :user }
  end
end
