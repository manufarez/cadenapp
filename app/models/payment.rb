class Payment < ApplicationRecord
  belongs_to :cadena
  belongs_to :participant
  belongs_to :user

  validate :sufficient_balance
  validate :max_payments

  private

  def sufficient_balance
    return unless amount > user.balance

    errors.add(:base, :insufficient_funds)
  end

  def max_payments
    return unless participant.present? && participant.payments_received > participant.payments_expected

    errors.add(:amount, "can't exceed payments_expected")
  end
end
