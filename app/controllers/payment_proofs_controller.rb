class PaymentProofsController < ApplicationController
  def new
    @cadena = Cadena.find(params[:cadena_id])
    @payment_proof = PaymentProof.new
  end

  def show
    @payment_proof = PaymentProof.find(params[:id])
  end

  def create
    @cadena = Cadena.find(params[:cadena_id])
    @payment_proof = PaymentProof.new(payment_proof_params)
    #Payment proof will need to fetch amount: nil, number: nil, account_type: nil, account_number: nil, transfer_timestamp: nil, bank_name: nil
    @payment_proof.cadena = @cadena
    @payment_proof.user = current_user
    @payment_proof.participant = @cadena.next_paid_participant
    @payment_proof.payment = Payment.new(cadena: @cadena, participant: @payment_proof.participant, user: current_user, amount: @cadena.installment_value, paid_at: Time.zone.now)
    if @payment_proof.save
      ExtractTextJob.perform_later(@payment_proof)
      redirect_to @cadena, notice: 'Payment proof was successfully created.'
    else
      render :new
    end
  end

  private

  def payment_proof_params
    params.require(:payment_proof).permit(:image)
  end
end
