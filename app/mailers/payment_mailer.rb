class PaymentMailer < ApplicationMailer
  def new_payment_email(payment)
    @payment = payment
    mail(
      to: @payment.receiver.email,
      subject: "Pago recibido por parte de #{@payment.sender.name}!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def payment_confirmation_email(payment)
    @payment = payment
    mail(
      to: @payment.sender.email,
      subject: "Gracias por pagarle a #{@payment.receiver.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def payment_reminder_email(participant, next_paid_participant)
    @participant = participant
    @next_paid_participant = next_paid_participant
    mail(
      to: @participant.user.email,
      subject: "Es hoy! Pagale a #{@next_paid_participant.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
