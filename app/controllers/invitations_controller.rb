class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[show destroy]
  before_action :set_cadena, only: %i[index new create accept]

  # GET /invitations or /invitations.json
  def index
    @invitations = Invitation.where(cadena_id: params[:cadena_id])
  end

  # GET /invitations/1 or /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @invitation = Invitation.new
  end

  def accept
    @invitation = @cadena.invitations.find_by(token: params[:token])

    if @invitation
      flash[:notice] = t('notices.cadena.invitation.welcome')
      if current_user
        @participation = Participant.new(cadena: @cadena, user: current_user)
        raise "Invalid participation: #{@participation.errors.full_messages.join(', ')}" unless @participation.valid?

        @participation.save
        @invitation.update(accepted: true)
        @cadena.save
        redirect_to @cadena
      else
        redirect_to new_user_registration_path(params: { token: params[:token] })
      end
    else
      flash[:error] = t('notices.cadena.invitation.token_error')
      redirect_to root_path
    end
  end

  # POST /invitations or /invitations.json
  def create # rubocop:disable Metrics/AbcSize
    @invitation = Invitation.new(invitation_params.merge(cadena_id: @cadena.id, sender: current_user))
    respond_to do |format|
      if @invitation.save
        format.html { redirect_to cadena_invitations_url, notice: t('notices.cadena.invitation.sent') }
        format.json { render :show, status: :created, location: @invitation }
      else
        flash[:error] = t('notices.cadena.invitation.error')
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1 or /invitations/1.json
  def destroy
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url, notice: t('notices.cadena.invitation.destroyed') }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_cadena
    @cadena = Cadena.find(params[:cadena_id])
  end

  # Only allow a list of trusted parameters through.
  def invitation_params
    params.require(:invitation).permit(:phone, :email, :first_name, :last_name, :accepted, :cadena_id, :sender_id)
  end
end
