class UserMailer < ApplicationMailer
  def partial_registration_confirmation_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Iniciaste inscripción en Cadenapp",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
