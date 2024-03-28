class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    if user.profile_complete?
      cadenas_path
    else
      user_update_profile_path(user)
    end
  end

  def set_date
    Timecop.travel(params[:global_date])
    redirect_back(fallback_location: root_path, notice: t("notices.global_date", global_date: Time.zone.now.strftime('%d/%m/%Y')))
  end

  private

  def authenticate_user!
    puts "THE CONTROLLER NAME IS #{controller_name} AND THE ACTION #{action_name}"

    if user_signed_in? || (devise_controller? && %w[new create destroy update].include?(action_name)) || params[:token] || controller_name == 'newsletter_subscribers' || (controller_name == 'passwords' && action_name == 'edit')
      return
    end

    redirect_to new_user_session_path, notice: t('notices.login_to_access')
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end
end
