FactoryBot.define do
    factory :order do
      association :user
      order_total { nil }
    end
end
  