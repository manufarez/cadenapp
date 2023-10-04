FactoryBot.define do
  factory :participant do
    cadena { nil }
    user { nil }
    is_admin { false }
    withdrawal_date { "2023-09-12" }
    position { 1 }
    status { "MyString" }
    payments_expected { 1 }
    payments_received { 1 }
    total_due { "9.99" }
  end
end
