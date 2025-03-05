class UserMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def partial_registration_confirmation_email(user)
    @user = user
    mail(
      to: @user.email,
      subject: "Iniciaste inscripción en Cadenapp",
    )
  end
end
