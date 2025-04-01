FactoryBot.define do
  factory :cadena do
    name { "Amigos del parque" }
    desired_participants { 15 }
    desired_installments { 15 }
    saving_goal { 1_500_000 }
    installment_value { 100_000 }
    start_date { Time.zone.tomorrow }
    periodicity { %w[monthly bimonthly].sample }
    end_date { Time.zone.tomorrow + ((periodicity == "monthly") ? desired_installments : desired_installments / 2).months }
    participants_approval { false }
    positions_assigned { false }
    admin { association :participant, cadena: instance }
  end
end
