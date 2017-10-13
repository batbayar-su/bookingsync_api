FactoryGirl.define do
  factory :booking do
    client_email { Faker::Internet.email }
    rental_id nil
    start_at { Faker::Date.forward(Faker::Number.between(0, 5)) }
    end_at { Faker::Date.forward(Faker::Number.between(5, 10)) }
    price { Faker::Number.number(3) }
  end
end