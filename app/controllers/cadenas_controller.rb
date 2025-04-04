class CadenasController < ApplicationController
  include ActiveStorage::SetCurrent
  before_action :set_cadena, only: %i[show edit update destroy assign_positions change_state start_participants_approval remove_participant]
  before_action :ask_profile_completion

  # GET /cadenas or /cadenas.json

  def index
    if current_user.is_admin
      @cadenas = Cadena.includes(:participants).all.order(state: :asc, name: :asc)
      render template: "cadenas/admin_index"
    else
      @user = current_user
      @cadenas = @user.cadenas.order(state: :desc, name: :asc)
      @payments = (@user.made_payments + @user.received_payments).sort_by(&:created_at).reverse
      render template: "cadenas/user_index"
    end
  end

  # GET /cadenas/1 or /cadenas/1.json
  def show
    @except_next_paid = @cadena
      &.participants_except_next_paid
      &.includes(user: {avatar_attachment: :blob})
      &.sort_by { |participant| participant.paid_next_participant? ? 0 : 1 }

    return if current_user.member_of?(@cadena) || current_user.is_admin?

    redirect_to root_path, alert: t("notices.cadena.access_forbidden")
  end

  # GET /cadenas/new
  def new
    @cadena = Cadena.new
  end

  # GET /cadenas/1/edit
  def edit
  end

  # POST /cadenas or /cadenas.json
  def create
    @cadena = Cadena.new(cadena_params)
    respond_to do |format|
      if @cadena.save && current_user
        admin = Participant.create(cadena: @cadena, user: current_user)
        @cadena.update(admin_id: admin.id)
        CadenaMailer.new_cadena_email(@cadena, current_user).deliver_later
        format.html { redirect_to cadena_url(@cadena), notice: t("notices.cadena.creation_success") }
        format.json { render :show, state: :created, location: @cadena }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cadenas/1 or /cadenas/1.json
  def update
    respond_to do |format|
      if @cadena.update(cadena_params)
        format.html { redirect_to cadena_url(@cadena), notice: t("notices.cadena.update_success") }
        format.json { render :show, status: :ok, location: @cadena }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  def change_state
    if params[:state].present? && params[:state] == "started"
      @cadena.resume
    elsif params[:state].present? && params[:state] == "stopped"
      @cadena.stop
    elsif params[:state].present? && params[:state] == "archived"
      @cadena.archive
    end
    redirect_to @cadena, notice: "State updated to #{@cadena.state}"
  end

  def start_participants_approval
    incomplete_users = @cadena.users.reject(&:profile_complete?)
    unless incomplete_users.empty?
      return redirect_to @cadena, notice: t("cadena.incomplete_profile_found", participant: incomplete_users.first.name)
    end

    @cadena.approve_participants
    respond_to do |format|
      format.html { redirect_to @cadena, notice: t("notices.cadena.start_participants_approval") }
    end
    return if Rails.application.config.seeding

    @cadena.participants.reject { |participant| participant == @cadena.admin }.each do |participant|
      CadenaMailer.participants_approval_email(@cadena, participant).deliver_later
    end
  end

  def assign_positions
    ActiveRecord::Base.transaction do
      @cadena.assign_positions
      @cadena.start
      unless Rails.application.config.seeding
        @cadena.participants.reject { |participant| participant == @cadena.admin }.each do |participant|
          CadenaMailer.positions_assigned_email(@cadena, participant).deliver_later
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to @cadena, notice: t("notices.cadena.positions_assigned") }
    end
  end

  def remove_participant
    return redirect_to cadena_path(@cadena), alert: t("notices.cadena.too_late") unless @cadena.start_date_is_future

    @participant = @cadena.participants.find(params[:participant_id])
    @participant.destroy
    CadenaMailer.participant_removed_email(@participant).deliver_later
    @cadena.back_to_pending
    redirect_to cadena_path(@cadena), notice: t("notices.cadena.user.removed")
  end

  # DELETE /cadenas/1 or /cadenas/1.json
  def destroy
    @cadena.destroy

    respond_to do |format|
      format.html { redirect_to cadenas_url, notice: t("notices.cadena.destroyed") }
      format.json { head :no_content }
    end
  end

  private

  def ask_profile_completion
    if (user_signed_in? && current_user.profile_complete?) || action_name == "complete_profile" || current_user.is_admin
      return
    end

    redirect_to user_complete_profile_path(current_user), notice: t("notices.user.profile_incomplete")
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_cadena
    @cadena = Cadena.eager_load(users: {avatar_attachment: :blob}).find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def cadena_params
    params.require(:cadena).permit(
      :name,
      :desired_participants,
      :desired_installments,
      :installment_value,
      :start_date,
      :end_date,
      :periodicity,
      :state,
      :saving_goal,
      :accepts_admin_terms
    )
  end
end
