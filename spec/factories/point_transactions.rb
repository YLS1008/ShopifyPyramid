FactoryBot.define do
  factory :point_transaction do
    user { nil }
    value { "9.99" }
    source { 1 }
  end
end
