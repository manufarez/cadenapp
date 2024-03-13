class InvitationMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def invitation_email(invitation)
    @invitation = invitation
    mail(
      to: @invitation.email,
      subject: "Invitación para hacer parte de la cadena #{@invitation.cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
