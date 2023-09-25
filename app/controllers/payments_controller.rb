class PaymentsController < ApplicationController
  before_action :find_cadena

  def create
    @payment = Payment.new(
      cadena: @cadena,
      participant_id: params[:participant_id],
      amount: @cadena.installment_value,
      user: current_user,
      paid_at: global_date
    )
    respond_to do |format|
      if process_payment
        format.html { redirect_to cadena_url(@payment.cadena), notice: t('cadena.payment_success') }
        format.json { render json: @payment.cadena, status: :created, location: @payment.cadena }
      else
        format.html { render @cadena, status: :unprocessable_entity }
        format.json { render json: @payment.cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  def process_payment
    return false unless @payment.valid?

    ActiveRecord::Base.transaction do
      sender = @payment.user
      receiver = @payment.participant
      sender.balance -= @payment.amount
      receiver.user.balance += @payment.amount
      receiver.payments_received += 1
      @payment.save && sender.save && receiver.save
    end
  end

  def make_all_payments
    @cadena.unpaid_turn_participants(global_date).each do |participant|
      @payment = Payment.new(
        cadena: @cadena,
        participant: @cadena.next_paid_participant(global_date),
        amount: @cadena.installment_value,
        user: participant.user,
        paid_at: global_date
      )
      process_payment if @payment.valid?
    end
    redirect_to @cadena, notice: t('cadena.fast_paid')
  end

  private

  def find_cadena
    @cadena = Cadena.find(params[:cadena_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :participant_id, :cadena_id)
  end
end
