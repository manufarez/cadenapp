class Payment < ApplicationRecord
  belongs_to :cadena
  belongs_to :participant
  belongs_to :user

  validate :sufficient_balance
  validate :max_payments
  validate :cadena_started?

  after_create :send_payment_email, unless: -> { Rails.application.config.seeding }
  before_destroy :decrement_payments
  after_save_commit :send_period_complete_email, if: :period_complete?, unless: -> { Rails.application.config.seeding }

  private

  def send_payment_email
    PaymentMailer.new_payment_email(self).deliver_later
  end

  def sufficient_balance
    return unless amount > user.balance

    errors.add(:base, :insufficient_funds)
  end

  def max_payments
    return unless participant.present? && participant.payments_received > participant.payments_expected

    errors.add(:amount, "can't exceed payments_expected")
  end

  def cadena_started?
    return true if cadena.started?

    errors.add(:cadena, "hasn't started or has been stopped")
  end

  def decrement_payments
    raise 'No participant associated with this payment!' unless participant

    participant.payments_received -= 1
    participant.save!
  end

  def period_complete?
    cadena.started? && cadena.period_progression == 100
  end

  def send_period_complete_email
    cadena.participants.each do |participant|
      CadenaMailer.period_complete_email(participant).deliver_later if cadena.period_progression >= 100
      CadenaMailer.cadena_over_email(participant).deliver_later if cadena.global_progression >= 100
    end
  end
end
