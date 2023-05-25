FactoryBot.define do
  factory :user do
    name { "nicolas" }
    email { "nicolas@gmail.com" }
    password { "password" }
    role { "admin" }
  end
end
