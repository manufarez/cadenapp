FactoryBot.define do
  factory :payment_proof do
    amount { "MyString" }
    number { "MyString" }
    account_type { "MyString" }
    account_number { "MyString" }
    transfer_timestamp { "2024-11-22 11:11:13" }
    bank_name { "MyString" }
  end
end
