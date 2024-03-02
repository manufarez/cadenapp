# Preview all emails at http://localhost:3000/rails/mailers/payment
class PaymentPreview < ActionMailer::Preview
  def new_payment_email_preview
    payment = Payment.last
    PaymentMailer.new_payment_email(payment)
  end

  def payment_confirmation_email_preview
    participant = Participant.find { |p| p.withdrawal_date && p.position && p.cadena.started? }
    next_paid_participant = participant.cadena.next_paid_participant
    PaymentMailer.payment_confirmation_email(participant.user, next_paid_participant)
  end

  def payment_reminder_email_preview
    participant = Participant.find { |p| p.withdrawal_date && p.position && p.cadena.started? }
    next_paid_participant = participant.cadena.next_paid_participant
    PaymentMailer.payment_reminder_email(participant, next_paid_participant)
  end
end
