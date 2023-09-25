class Payment < ApplicationRecord
  belongs_to :cadena
  belongs_to :participant
  belongs_to :user

  validate :max_payments

  private

  def max_payments
    return unless participant.present? && participant.payments_received > participant.payments_expected

    errors.add(:payments_received, "can't exceed payments_expected")
  end
end
