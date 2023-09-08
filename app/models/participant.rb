class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :cadena
  has_many :received_payments, class_name: 'Payment', dependent: :nullify

  def received_payments
    Payment.where(participant: self)
  end

  delegate :name, to: :user
end
