class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def login_as(user)
    sign_out(current_user) if current_user
    sign_in(user)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.is_admin?
      cadenas_path
    else
      root_path
    end
  end

  def after_sign_in_path_for(resource)
    complete_profile_path(resource)
  end

  private

  def authenticate_user!
    unless user_signed_in? && current_user.is_admin? || devise_controller? && %w[new create destroy update].include?(action_name)
      redirect_to new_user_session_path, notice: "Please login to access this page."
    end
  end
end
