module ApplicationHelper
  def number_to_currency_with_k(number, options)
    "#{number_to_currency(number / 1000.0, options)}k"
  end

  def link_to_cond(cond, *args, &block)
    if cond
      link_to(*args, &block)
    else
      capture(&block)
    end
  end
end
