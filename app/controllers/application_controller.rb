class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  def login_as(user)
    sign_out(current_user) if current_user
    sign_in(user)
  end

  def after_sign_in_path_for(resource)
    if resource.is_a?(User) && resource.is_admin?
      logger.debug "admin user"
      cadenas_path
    else
      root_path
    end
  end

  private

  def authenticate_user!
    unless user_signed_in? && current_user.is_admin? || devise_controller? && %w[new create destroy].include?(action_name)
      redirect_to new_user_session_path, notice: "Please login to access this page."
    end
  end
end
