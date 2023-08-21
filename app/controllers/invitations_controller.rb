class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[ show edit update destroy ]

  # GET /invitations or /invitations.json
  def index
    @invitations = Invitation.where(cadena_id: params[:cadena_id])
  end

  # GET /invitations/1 or /invitations/1.json
  def show
  end

  # GET /invitations/new
  def new
    @cadena = Cadena.find(params[:cadena_id])
    @invitation = Invitation.new
  end

  # GET /invitations/1/edit
  def edit
  end

  def accept
    @cadena = Cadena.find(params[:cadena_id])
    @invitation = @cadena.invitations.find_by(token: params[:id])

    if @invitation
      # Handle invitation acceptance logic
      flash[:error] = 'Bienvenido a la cadena!'
      redirect_to @cadena
    else
      flash[:error] = 'Invalid invitation token.'
      redirect_to root_path
    end
  end

  # POST /invitations or /invitations.json
  def create
    @cadena = Cadena.find(params[:cadena_id])
    @invitation = Invitation.new(invitation_params)
    @invitation.cadena_id = @cadena.id
    @invitation.sender = current_user

    respond_to do |format|
      if @invitation.save
        InvitationMailer.invite_email(@invitation).deliver_now
        format.html { redirect_to cadena_invitations_url, notice: "Invitation was successfully sent" }
        format.json { render :show, status: :created, location: @invitation }
      else
        flash[:error] = 'Invitation failed to send'
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /invitations/1 or /invitations/1.json
  def update
    respond_to do |format|
      if @invitation.update(invitation_params)
        format.html { redirect_to invitation_url(@invitation), notice: "Invitation was successfully updated." }
        format.json { render :show, status: :ok, location: @invitation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @invitation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitations/1 or /invitations/1.json
  def destroy
    @invitation.destroy

    respond_to do |format|
      format.html { redirect_to invitations_url, notice: "Invitation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invitation
      @invitation = Invitation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def invitation_params
      params.require(:invitation).permit(:phone, :email, :first_name, :last_name, :accepted, :cadena_id, :sender_id)
    end
end
