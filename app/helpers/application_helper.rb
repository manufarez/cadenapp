module ApplicationHelper
  def number_to_currency_with_k(number, options)
    "#{number_to_currency(number / 1000.0, options)}k"
  end

  def link_to_cond(condition, name, options = {}, html_options = {}, &block)
    if condition
      link_to(name, options, html_options, &block)
    elsif block
      block.arity <= 1 ? capture(name, &block) : capture(name, options, html_options, &block)
    else
      ERB::Util.html_escape(name)
    end
  end
end
