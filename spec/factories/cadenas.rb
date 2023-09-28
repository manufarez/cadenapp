FactoryBot.define do
  factory :cadena do
    name { "MyString" }
    desired_participants { 1 }
    desired_installments { 1 }
    saving_goal { "9.99" }
    installment_value { "9.99" }
    start_date { "2023-09-12" }
    end_date { "2023-09-12" }
    periodicity { "monthly" }
    status { "pending" }
    balance { "9.99" }
    participants_approval { false }
    positions_assigned { false }
    association :admin, factory: :user
  end
end
