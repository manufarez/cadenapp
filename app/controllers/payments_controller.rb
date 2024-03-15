class PaymentsController < ApplicationController
  before_action :set_cadena

  def create
    @payment = Payment.new(payment_params)
    respond_to do |format|
      if @payment.valid?
        @payment.process_payment
        format.html { redirect_to cadena_url(@payment.cadena), notice: t('cadena.payment_success') }
        format.json { render json: @payment.cadena, status: :created, location: @payment.cadena }
        unless Rails.application.config.seeding
          PaymentMailer.payment_confirmation_email(@payment).deliver_later
          PaymentMailer.new_payment_email(@payment).deliver_later
        end
      else
        format.html { redirect_to cadena_url(@payment.cadena), notice: @payment.errors.full_messages.to_sentence }
        format.json { render json: @payment.cadena.errors, status: :unprocessable_entity }
      end
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
        @payment.process_payment
      else
        error_messages << participant.user.name.to_s
      end
    end
    if @cadena.unpaid_turn_participants.count.positive?
      redirect_to @cadena
      flash[:notice] = "#{t('activerecord.errors.models.payment.insufficient_funds')} - #{error_messages.first}"
    else
      redirect_to @cadena, notice: t('cadena.fast_paid')
    end
  end

  private

  def set_cadena
    @cadena = Cadena.find(params[:cadena_id])
  end

  def payment_params
    params.require(:payment).permit(:amount, :participant_id, :user_id, :cadena_id, :paid_at)
  end
end
