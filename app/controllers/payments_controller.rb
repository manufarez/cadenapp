class PaymentsController < ApplicationController
  before_action :find_cadena

  def create
    @payment = Payment.new(
      cadena: @cadena,
      participant_id: params[:participant_id],
      amount: @cadena.installment_value,
      user: current_user,
      paid_at: session[:global_date] ? session[:global_date] : Time.zone.now
    )
    respond_to do |format|
      if @payment.save
        format.html { redirect_to cadena_url(@payment.cadena), notice: t('cadena.payment_success') }
        format.json { render json: @payment.cadena, status: :created, location: @payment.cadena }
      else
        format.html { render @cadena, status: :unprocessable_entity }
        format.json { render json: @payment.cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def find_cadena
    @cadena = Cadena.find(params[:cadena_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :participant_id, :cadena_id)
  end
end
