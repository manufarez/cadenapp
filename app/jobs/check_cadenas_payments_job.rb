class CheckCadenasPaymentsJob < ApplicationJob
  queue_as :default

  def perform
    ongoing_cadenas = Cadena.where(state: ['started', 'stopped'])
    return if ongoing_cadenas.empty?

    unpaid_cadenas = ongoing_cadenas.select do |cadena|
      cadena.unpaid_previous_participants.present?
    end
    return if unpaid_cadenas.empty?

    unpaid_cadenas.each do |cadena|
      cadena.participants.each { |participant| CadenaMailer.unpaid_turn_detected(participant).deliver_later }
      CadenaMailer.unpaid_turn_admin_alert(cadena).deliver_later
      cadena.update(state: 'stopped')
    end
  end
end
