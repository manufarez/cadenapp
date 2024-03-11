class UsersController < ApplicationController
  include ActiveStorage::SetCurrent
  include ActionView::Helpers::NumberHelper
  skip_before_action :authenticate_user!, only: %i[complete_profile update]
  before_action :set_user, except: %i[index]
  before_action :authenticate_user!, only: [:deposit]
  before_action :authorize_deposit_access, only: [:deposit]
  before_action :ask_profile_completion, except: %i[update abandon_complete_profile]

  def index
    if current_user.is_admin?
      @users = User.includes(:made_payments, :received_payments).all.order(:first_name, :last_name)
    else
      redirect_to cadenas_path, notice: t('notices.user.not_admin', user_email: current_user.email)
    end
  end

  def show
    if @user == current_user || current_user.is_admin?
      @cadenas = @user.cadenas.order(state: :desc, name: :asc)
      @payments = (@user.made_payments + @user.received_payments).sort_by(&:created_at).reverse
    else
      redirect_to(current_user, notice: t('notices.user.access_forbidden'))
    end
  end

  def login_as
    sign_in(@user, scope: :user)
    redirect_to users_path
  end

  def complete_profile
  end

  def abandon_complete_profile
    if current_user.profile_complete?
      redirect_to current_user
    else
      redirect_to root_path
    end
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

  def payment_methods
    respond_to do |format|
      format.turbo_stream {
        render turbo_stream: turbo_stream.replace("choose_payment_method_btn", partial: "payment_methods", locals: { deposit_amount: params[:deposit_amount] })
      }
    end
  end

  def quick_deposit
    amount = params[:deposit_amount].to_i
    @user.update(balance: @user.balance + amount)
    redirect_to cadenas_path, status: :see_other, notice: "💸 Saldo aumentado de #{number_to_currency(amount, precision: 0)}"
  end

  private

  def ask_profile_completion
    return if current_user.profile_complete? || action_name == 'complete_profile' || current_user.is_admin

    redirect_to user_complete_profile_path(current_user), notice: t('notices.user.profile_incomplete')
  end

  def authorize_deposit_access
    return if current_user == @user || current_user.is_admin?

    redirect_to root_path, alert: t('notices.user.access_forbidden')
  end

  def set_user
    @user = User.find(params[:user_id] || params[:id])
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
