class PaymentReminderJob < ApplicationJob
  queue_as :default

  def perform
    cadenas = Cadena.joins(:participants).where(participants: { withdrawal_date: Time.zone.now.to_date }, state: 'started').distinct
    return if cadenas.empty?

    cadenas.each do |cadena|
      cadena.participants_except_next_paid.each do |participant|
        PaymentMailer.payment_reminder_email(participant, cadena.next_paid_participant).deliver_later
      end
    end
  end
end
