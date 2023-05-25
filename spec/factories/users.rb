FactoryBot.define do
  factory :user do
    name { "nicolas" }
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password" }
    role { "admin" }
  end
end
