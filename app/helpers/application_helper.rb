module ApplicationHelper
  def global_date
    session[:global_date] ||= Time.zone.today
  end
end
