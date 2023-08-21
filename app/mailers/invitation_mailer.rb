class InvitationMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def invite_email(invitation)
    @invitation = invitation
    mail(to: @invitation.email, subject: "Bienvenido a la cadena! #{@invitation.cadena.name}", from: 'contacto@cadenapp.com', track_opens: true, message_stream: 'outbound')
  end
end
