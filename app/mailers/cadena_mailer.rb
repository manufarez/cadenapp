class CadenaMailer < ApplicationMailer
  def new_cadena_email(cadena, admin)
    @cadena = cadena
    @admin = admin
    mail(
      to: @admin.email,
      subject: "Cadena #{@cadena.name} creada",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def new_participant_email(cadena, invitation)
    @cadena = cadena
    @participant = invitation
    mail(
      to: @cadena.admin.email,
      subject: "#{@participant.name} has joined #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def welcome_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "Welcome to #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def positions_assigned_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "The order for #{@cadena.name} has been set!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def participants_approval_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "The cadena #{@cadena.name} has gathered all its participants!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
