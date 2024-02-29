FactoryBot.define do
  factory :participant do
    withdrawal_date { "2023-09-12" }
    position { 1 }
    status { "MyString" }
    payments_expected { 1 }
    payments_received { 1 }
    cadena { association :cadena, participant: instance }
  end
end
