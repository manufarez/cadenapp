FactoryBot.define do
  factory :newsletter_subscriber do
    email { "MyString" }
    ip_address { "MyString" }
    user_agent { "MyString" }
    user { nil }
  end
end
