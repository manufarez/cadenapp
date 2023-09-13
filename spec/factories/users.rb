FactoryBot.define do
  factory :user do
    email { "abc@abc.com" }
    encrypted_password { "MyString" }
    reset_password_token { "MyString" }
    reset_password_sent_at { "2023-09-12 17:09:50" }
    remember_created_at { "2023-09-12 17:09:50" }
    first_name { "MyString" }
    last_name { "MyString" }
    identification_number { "MyString" }
    identification_type { "MyString" }
    identification_issued_at { "MyString" }
    sex { "MyString" }
    dob { "2023-09-12" }
    password { "MyString" }
    password_confirmation { "MyString" }
    phone { "MyString" }
    address { "MyString" }
    zip { "MyString" }
    city { "MyString" }
    is_admin { false }
    accepts_terms { false }
  end
end
