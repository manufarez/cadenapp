FactoryBot.define do
  factory :invitation do
    token { "MyString" }
    email { "MyString" }
    phone { "MyString" }
    first_name { "MyString" }
    last_name { "MyString" }
    accepted { false }
  end
end
