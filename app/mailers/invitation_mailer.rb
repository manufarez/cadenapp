class InvitationMailer < ApplicationMailer
  default from: 'contacto@cadenapp.com'

  def invitation_email(invitation)
    @invitation = invitation
    mail(
      to: @invitation.email,
      subject: "Invitación para hacer parte de la cadena #{@invitation.cadena.name}"
    ).tap do |message|
      message.mailgun_options = {
        "tracking-opens" => true,
        "tracking-clicks" => "htmlonly"
      }
    end
  end
end
