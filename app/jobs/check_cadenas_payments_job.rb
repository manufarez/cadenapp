class CheckCadenasPaymentsJob < ApplicationJob
  queue_as :default

  def perform
    cadenas = Cadena.where(status: ['started', 'stopped'])
    return if cadenas.empty?

    cadenas.each do |cadena|
      cadena..update(status: 'stopped', admin_status_change: true) if cadena.unpaid_previous_participants.present?
    end
  end
end
