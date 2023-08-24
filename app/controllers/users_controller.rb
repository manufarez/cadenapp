class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[complete_profile update]
  before_action :set_user, only: %i[update complete_profile show]
  before_action :ask_profile_completion, except: %i[update]

  def index
    if current_user.is_admin?
      @users = User.all
    else
      redirect_to cadenas_path, notice: t('notices.user.not_admin', user_email: current_user.email)
    end
  end

  def show
  end

  def login_as
    user = User.find(params[:id])
    sign_in(user, scope: :user)
    redirect_to users_path
  end

  def complete_profile
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to current_user, notice: t('notices.user.update') }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :complete_profile, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def ask_profile_completion
    return if current_user.profile_complete? || action_name == 'complete_profile'

    redirect_to complete_profile_path(current_user), notice: t('notices.user.profile_incomplete')
  end

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :phone,
      :dob,
      :sex,
      :address,
      :city,
      :zip,
      :identification_number,
      :identification_type,
      :accepts_terms,
      :avatar
    )
  end
end
