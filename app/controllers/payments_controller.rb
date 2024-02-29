class PaymentsController < ApplicationController
  before_action :find_cadena

  def create
    @payment = Payment.new(cadena: @cadena, participant_id: params[:participant_id], amount: @cadena.installment_value, user: current_user, paid_at: Time.zone.now)
    respond_to do |format|
      if @payment.valid?
        process_payment
        format.html { redirect_to cadena_url(@payment.cadena), notice: t('cadena.payment_success') }
        format.json { render json: @payment.cadena, status: :created, location: @payment.cadena }
      else
        format.html { redirect_to cadena_url(@payment.cadena), notice: @payment.errors.full_messages.to_sentence }
        format.json { render json: @payment.cadena.errors, status: :unprocessable_entity }
      end
    end
  end

  def process_payment
    ActiveRecord::Base.transaction do
      sender = @payment.user
      receiver = @payment.participant
      sender.balance -= @payment.amount
      receiver.user.balance += @payment.amount
      receiver.payments_received += 1
      @payment.save(validate: false) && sender.save && receiver.save
    end
  end

  def make_all_payments
    error_messages = []
    @cadena.unpaid_turn_participants.each do |participant|
      @payment = Payment.new(
        cadena: @cadena,
        participant: @cadena.next_paid_participant,
        amount: @cadena.installment_value,
        user: participant.user,
        paid_at: Time.zone.now
      )
      if @payment.valid?
        process_payment
      else
        error_messages << participant.user.name.to_s
      end
    end
    if @cadena.unpaid_turn_participants.count.positive?
      redirect_to @cadena
      flash[:notice] = "#{@payment.errors.full_messages.join(', ')} - #{error_messages.first}"
    else
      redirect_to @cadena, notice: t('cadena.fast_paid')
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
