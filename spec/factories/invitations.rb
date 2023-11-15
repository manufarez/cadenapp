FactoryBot.define do
  factory :invitation do
    token { Faker::Internet.device_token }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.phone_number }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    accepted { false }
    cadena
  end
end
