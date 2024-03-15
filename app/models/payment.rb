class Payment < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  belongs_to :cadena
  belongs_to :participant
  belongs_to :user

  validate :sufficient_balance
  validate :max_payments
  validate :cadena_started?, unless: -> { Rails.application.config.seeding }

  after_create_commit :global_complete?
  before_destroy :decrement_payments
  after_save_commit :send_period_complete_email, if: :period_complete?, unless: -> { Rails.application.config.seeding }

  def process_payment
    ActiveRecord::Base.transaction do
      sender = self.sender
      receiver = self.receiver
      begin
        save!
        sender.balance -= amount
        receiver.user.balance += amount
        receiver.payments_received += 1
        sender.save!
        receiver.save!
        receiver.user.save!
      rescue ActiveRecord::RecordInvalid => e
        puts e.errors.full_messages.join(', ')
        raise ActiveRecord::Rollback
      end
    end
  end

  def receiver
    Participant.find(participant_id)
  end

  def sender
    User.find(user_id)
  end

  private

  def sufficient_balance
    return unless amount > user.balance

    errors.add(:base, :insufficient_funds)
  end

  def max_payments
    return unless participant.present? && participant.payments_received > participant.payments_expected

    errors.add(:amount, "can't exceed payments_expected")
  end

  def cadena_started?
    return true if cadena.started? && Time.zone.now.to_date >= cadena.start_date

    errors.add(:cadena, "no ha empezado (empieza: #{cadena.start_date.strftime('%d/%m/%y')}) o ha sido pausada")
  end

  def decrement_payments
    raise 'No participant associated with this payment!' unless participant

    participant.payments_received -= 1
    participant.save!
    cadena.resume if cadena.finished?
  end

  def period_complete?
    cadena.started? && cadena.period_progression == 100
  end

  def global_complete?
    return true if cadena.finished?

    if cadena.started? && cadena.global_progression == 100
      cadena.finish
      true
    end

    false
  end

  def send_period_complete_email
    cadena.participants.each do |participant|
      CadenaMailer.period_complete_email(participant).deliver_later if cadena.period_progression >= 100
      CadenaMailer.cadena_over_email(participant).deliver_later if cadena.global_progression >= 100
    end
  end
end
