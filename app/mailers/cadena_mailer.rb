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
      to: @cadena.admin.user.email,
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

  def period_complete_email(participant)
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "Everyone in #{@participant.cadena.name} has paid for this period!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def cadena_over_email(participant)
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "Everyone in #{@participant.cadena.name} has paid for this period!",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def participant_removed_email(participant)
    @participant = participant
    mail(
      to: @participant.user.email,
      subject: "You have been removed from the cadena #{@participant.cadena.name}",
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
      subject: "Thank you for paying #{@receiver_participant.name}",
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
      subject: "It's today! Reminder to pay #{@next_paid_participant}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
