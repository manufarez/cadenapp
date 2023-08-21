class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def login_as(user)
    sign_out(current_user) if current_user
    sign_in(user)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User)
      cadenas_path
    end
  end

  def after_sign_up_path_for(resource)
    complete_profile_path(resource)
  end

  def set_date
    session[:global_date] = Date.parse(params[:global_date])
    redirect_back(fallback_location: root_path, alert: "Global date set to #{session[:global_date].strftime('%d/%m/%y')}")
  end

  private

  def authenticate_user!
    unless user_signed_in? || devise_controller? && %w[new create destroy update].include?(action_name)
      redirect_to new_user_session_path, notice: "Please login to access this page."
    end
  end
end
