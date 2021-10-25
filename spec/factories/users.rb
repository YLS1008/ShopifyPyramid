FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'Passw0rd' }
    password_confirmation { |u| u.password }
    name { 'Test Name' }
  end
end
