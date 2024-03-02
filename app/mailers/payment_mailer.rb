class PaymentMailer < ApplicationMailer
  def new_payment_email(payment)
    @payment = payment
    mail(
      to: @payment.user.email,
      subject: "Pago recibido por parte de #{@payment.participant.name}!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def payment_confirmation_email(sender_user, receiver_participant)
    @sender_user = sender_user
    @receiver_participant = receiver_participant
    mail(
      to: @sender_user.email,
      subject: "Gracias por pagarle a #{@receiver_participant.name}",
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
