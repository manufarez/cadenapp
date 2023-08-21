module ApplicationHelper
  def global_date
    session[:global_date] ||= Date.today
  end
end
