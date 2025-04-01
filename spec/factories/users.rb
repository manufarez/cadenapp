FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    identification_number { "MyString" }
    identification_type { "MyString" }
    identification_issued_at { Date.today }
    sex { ["M", "F"].sample }
    dob { Date.today }
    password { Faker::Internet.password }
    password_confirmation { password }
    phone { Faker::PhoneNumber.phone_number }
    address { Faker::Address.full_address }
    zip { Faker::Address.zip }
    city { Faker::Address.city }
    is_admin { true }
    accepts_terms { true }

    after(:build) do |user|
      user.avatar.attach(
        io: File.open("#{Rails.root}/app/assets/images/default_avatar.png"),
        filename: "default_avatar.png"
      )
    end
  end
end
