class CheckCadenasPaymentsJob < ApplicationJob
  queue_as :default

  def perform
    cadenas = Cadena.where(status: ['started', 'stopped'])
    return if cadenas.empty?

    cadenas.each do |cadena|
      cadena.update_columns(status: 'stopped') if cadena.unpaid_previous_participants.present?
    end
  end
end
