class ProgressionMailer < ApplicationMailer
  def period_complete_email(participant)
    @participant = participant
    @global_date = Time.zone.now
    mail(
      to: @participant.user.email,
      subject: "Everyone in #{@participant.cadena.name} has paid for this period!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
