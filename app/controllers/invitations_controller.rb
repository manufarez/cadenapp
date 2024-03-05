class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[destroy]
  before_action :set_cadena, only: %i[index new create accept decline]

  def index
    @invitations = Invitation.where(cadena_id: params[:cadena_id])
  end

  def new
    if @cadena.start_date_is_future
      @invitation = Invitation.new
    else
      redirect_to cadena_invitations_path, notice: t('notices.cadena.too_late', start_date: @cadena.start_date.strftime('%d/%m/%Y'))
    end
  end

  def accept
    @invitation = @cadena.invitations.find_by(token: params[:token])

    return redirect_to root_path, notice: t('notices.cadena.invitation.token_error') unless @invitation
    return redirect_to root_path, notice: t('notices.cadena.too_late') unless @cadena.start_date_is_future
    return redirect_to root_path, notice: t('notices.cadena.full') unless @cadena.missing_participants.positive?

    if current_user # Allow users who have an account to join
      @participation = Participant.new(cadena: @cadena, user: current_user)
      return redirect_to root_path, notice: @participation.errors.full_messages.join(', ') unless @participation.valid?

      flash[:notice] = t('notices.cadena.invitation.welcome')
      @participation.save
      @invitation.update(accepted: true)
      @cadena.complete if @cadena.missing_participants.zero?
      redirect_to @cadena
    else
      redirect_to new_user_registration_path(params: { token: params[:token] })
    end
  end

  def decline
    @invitation = @cadena.invitations.find_by(token: params[:token])
    respond_to do |format|
      if @invitation.update(accepted: false)
        format.html { redirect_to root_path, notice: t('notices.cadena.invitation.declined') }
      else
        format.html { redirect_to cadena_preview_path(token: @invitation.token), notice: @invitation.errors.full_messages.join(', '), status: :unprocessable_entity }
      end
    end
  end

  def create # rubocop:disable Metrics/AbcSize
    @invitation = Invitation.new(invitation_params.merge(cadena_id: @cadena.id, sender: current_user))
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to cadena_invitations_url, notice: t('notices.cadena.invitation.sent') }
      else
        flash[:error] = t('notices.cadena.invitation.error')
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url, notice: t('notices.cadena.invitation.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_cadena
    @cadena = Cadena.find(params[:cadena_id])
  end

  def invitation_params
    params.require(:invitation).permit(:phone, :email, :first_name, :last_name, :accepted, :cadena_id, :sender_id)
  end
end
