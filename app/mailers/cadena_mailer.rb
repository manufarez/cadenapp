class CadenaMailer < ApplicationMailer
  default from: "contacto@cadenapp.com"

  def new_cadena_email(cadena, admin)
    @cadena = cadena
    @admin = admin
    mail(
      to: @admin.email,
      subject: "Cadena #{@cadena.name} creada"
    )
  end

  def new_participant_email(cadena, invitation)
    @cadena = cadena
    @participant = invitation
    mail(
      to: @cadena.admin.email,
      subject: "#{@participant.name} se ha unido a la cadena #{@cadena.name}"
    )
  end

  def welcome_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Bienvenido a la cadena #{@cadena.name}"
    )
  end

  def positions_assigned_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "El orden de la cadena #{@cadena.name} ha sido definido"
    )
  end

  def participants_approval_email(cadena, participant)
    @cadena = cadena
    @participant = participant
    mail(
      to: @participant.email,
      subject: "La lista de participantes de la cadena #{@cadena.name} está completa"
    )
  end

  def period_complete_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Todos los participantes de #{@participant.cadena.name} han pagado su cuota para el periodo"
    )
  end

  def cadena_over_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "La cadena #{@participant.cadena.name} ha terminado"
    )
  end

  def participant_removed_email(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Has sido retirado de la cadena #{@participant.cadena.name}"
    )
  end

  def unpaid_turn_detected(participant)
    @participant = participant
    mail(
      to: @participant.email,
      subject: "Retraso de pago en la cadena #{@participant.cadena.name}"
    )
  end

  def unpaid_turn_admin_alert(cadena)
    @cadena = cadena
    mail(
      to: User.where(is_admin: true).pluck(:email),
      subject: "Alerta : Retraso de pago en la cadena #{@cadena.name}"
    )
  end

  def remind_admin_to_send_list(cadena)
    @cadena = cadena
    mail(
      to: @cadena.admin.email,
      subject: "La cadena #{@cadena.name} esta completa, puedes enviar la lista"
    )
  end

  def remind_admin_to_generate_order(cadena)
    @cadena = cadena
    mail(
      to: @cadena.admin.email,
      subject: "Puedes generar el orden de la cadena #{@cadena.name}"
    )
  end
end
