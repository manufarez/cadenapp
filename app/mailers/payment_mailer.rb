class PaymentMailer < ApplicationMailer
  def new_payment_email(payment)
    @payment = payment
    mail(
      to: @payment.user.email,
      subject: "New payment from #{@payment.participant.name}!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
