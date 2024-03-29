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
      subject: "#{@participant.name} se ha unido a la cadena #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def welcome_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Bienvenido a la cadena #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def positions_assigned_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "El orden de la cadena #{@cadena.name} ha sido definido",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def participants_approval_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "La lista de participantes de la cadena #{@cadena.name} está completa",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def period_complete_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Todos los participantes de #{@participant.cadena.name} han pagado su cuota para el periodo",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def cadena_over_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "La cadena #{@participant.cadena.name} ha terminado",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def participant_removed_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Has sido retirado de la cadena #{@participant.cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def unpaid_turn_detected(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Retraso de pago en la cadena #{@participant.cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def unpaid_turn_admin_alert(cadena)
    @cadena = cadena
    mail(
      to: User.where(is_admin: true).pluck(:email),
      subject: "Alerta : Retraso de pago en la cadena #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def remind_admin_to_send_list(cadena)
    @cadena = cadena
    mail(
      to: @cadena.admin.email,
      subject: "La cadena #{@cadena.name} esta completa, puedes enviar la lista",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end

  def remind_admin_to_generate_order(cadena)
    @cadena = cadena
    mail(
      to: @cadena.admin.email,
      subject: "Puedes generar el orden de la cadena #{@cadena.name}",
      from: 'contacto@cadenapp.com',
      track_opens: true,
      message_stream: 'outbound'
    )
  end
end
