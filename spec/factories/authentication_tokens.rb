FactoryBot.define do
  factory :authentication_token do
    user { nil }
    token { "MyString" }
    expires_at { "2021-10-25 23:33:24" }
    valid { false }
  end
end
