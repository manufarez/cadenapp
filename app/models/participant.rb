class Participant < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :cadena, optional: true
  has_many :received_payments, class_name: 'Payment', dependent: :nullify
  has_many :made_payments, through: :users, source: :made_payments, dependent: :nullify

  delegate :name, to: :user
  delegate :first_name, to: :user
  delegate :last_name, to: :user
  delegate :avatar, to: :user

  def paid_next_participant?(cadena, current_date)
    next_participant = cadena.next_paid_participant(current_date)
    if next_participant == self
      true
    else
      Payment.where(user: user, participant: next_participant).present?
    end
  end

  def paid_by_everyone
    payments_expected == payments_received && payments_received.positive?
  end
end
