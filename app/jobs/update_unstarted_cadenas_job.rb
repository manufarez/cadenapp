class UpdateUnstartedCadenasJob < ApplicationJob
  queue_as :default

  def perform
    cadenas = Cadena.where(start_date: 1.day.from_now).where.not(state: 'started')
    return if cadenas.empty?

    cadenas.each do |cadena|
      cadena.start_date += 1.day
      cadena.end_date += 1.day
      cadena.save(validate: false)
    end
  end
end
