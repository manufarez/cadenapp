module ApplicationHelper
  def global_date
    session[:global_date] ||= Time.zone.today
  end

  def number_to_currency_with_k(number, options)
    "#{number_to_currency(number / 1000.0, options)}k"
  end
end
