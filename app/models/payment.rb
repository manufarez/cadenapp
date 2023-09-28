class Payment < ApplicationRecord
  belongs_to :cadena
  belongs_to :participant
  belongs_to :user

  validate :sufficient_balance
  validate :max_payments

  after_create :send_payment_email, unless: -> { Rails.application.config.seeding }
  before_destroy :decrement_payments_expected
  after_commit :send_period_complete_email, if: :period_complete?

  private

  def send_payment_email
    PaymentMailer.new_payment_email(self).deliver_now
  end

  def sufficient_balance
    return unless amount > user.balance

    errors.add(:base, :insufficient_funds)
  end

  def max_payments
    return unless participant.present? && participant.payments_received > participant.payments_expected

    errors.add(:amount, "can't exceed payments_expected")
  end

  def decrement_payments_expected
    participant.update(payments_received: participant.payments_received - 1)
  end

  def period_complete?
    cadena.started? && cadena.period_progression(Time.zone.now) >= 100
  end

  def send_period_complete_email
    cadena.participants.each { |participant| ProgressionMailer.period_complete_email(participant).deliver_now }
  end
end
