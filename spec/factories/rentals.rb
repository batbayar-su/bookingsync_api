FactoryGirl.define do
  factory :rental do
    name { Faker::Lorem.words(3).join(' ') }
    daily_rate { Faker::Number.number(3) }
  end
end