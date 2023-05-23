class CadenasController < ApplicationController
  before_action :set_cadena, only: %i[ show edit update destroy ]

  # GET /cadenas or /cadenas.json
  def index
    @cadenas = Cadena.all
  end

  # GET /cadenas/1 or /cadenas/1.json
  def show
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

  def shuffle
    @cadena = Cadena.find(params[:id])
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
