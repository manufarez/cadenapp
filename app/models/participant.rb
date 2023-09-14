class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :cadena
  has_many :received_payments, class_name: 'Payment', dependent: :nullify
  has_many :made_payments, class_name: 'Payment', dependent: :nullify

  delegate :name, to: :user
end
