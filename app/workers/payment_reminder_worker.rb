require 'sidekiq-scheduler'

class PaymentReminderWorker
  include Sidekiq::Worker

  def perform
    cadenas = Cadena.joins(:participants).where(participants: { withdrawal_date: Time.zone.now.to_date }).distinct
    return if cadenas.empty?

    cadenas.each do |cadena|
      cadena.participants_except_next_paid.each do |participant|
        CadenaMailer.payment_reminder_email(participant, cadena.next_paid_participant).deliver_now
      end
    end
  end
end
