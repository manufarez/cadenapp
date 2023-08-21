class CadenasController < ApplicationController
  before_action :set_cadena, only: %i[ show edit update destroy ]

  # GET /cadenas or /cadenas.json
  def index
    if current_user.is_admin?
      @cadenas = Cadena.all
    else
      @cadenas = current_user.cadenas
    end
  end

  # GET /cadenas/1 or /cadenas/1.json
  def show
    if current_user.belongs_to_cadena?(@cadena) || current_user.is_admin?
      # Proceed with showing the cadena's details
    else
      redirect_to root_path, alert: "Ud. no tiene acceso a esta cadena."
    end
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
      if @cadena.save
        format.html { redirect_to cadena_url(@cadena), notice: "Cadena was successfully created." }
        format.json { render :show, status: :created, location: @cadena }
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
        format.html { redirect_to cadena_url(@cadena), notice: "Cadena was successfully updated." }
        format.json { render :show, status: :ok, location: @cadena }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  def request_approval
    @cadena = Cadena.find(params[:id])
    @cadena.status = 'approval_requested'
    @cadena.save
    redirect_back(fallback_location: root_path, alert: "Request for approval has been sent to participants")
  end

  def assign_positions
    @cadena = Cadena.find(params[:id])
    participations = @cadena.participations
    participations.shuffle
    participations.each_with_index do |participation, index|
      participation.position = index + 1
      participation.save
    end
    @cadena.status = 'started'
    @cadena.save
  end

  def remove_user
    @cadena = Cadena.find(params[:id])
    user = User.find(params[:user_id])

    participation = @cadena.participations.find_by(user: user)
    if participation
      participation.destroy
      @cadena.set_status
      redirect_to cadena_path(@cadena), notice: 'User removed from cadena.'
    else
      redirect_to cadena_path(@cadena), alert: 'User not found in cadena.'
    end
  end

  # DELETE /cadenas/1 or /cadenas/1.json
  def destroy
    @cadena.destroy

    respond_to do |format|
      format.html { redirect_to cadenas_url, notice: "Cadena was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cadena
      @cadena = Cadena.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cadena_params
      params.require(:cadena).permit(:name, :total_participants, :installments, :installment_value, :start_date, :end_date, :periodicity, :status, :balance)
    end
end
