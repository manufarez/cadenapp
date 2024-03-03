class CadenaPreviewController < ApplicationController
  def show
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation && @invitation.accepted.nil?
      @cadena = @invitation.cadena
    elsif @invitation&.accepted || @invitation&.older_than_1h
      flash[:error] = t('notices.cadena.invitation.expired')
      redirect_to root_path
    elsif @invitation.accepted == false
      flash[:error] = t('notices.cadena.invitation.already_declined')
      redirect_to root_path
    else
      flash[:error] = t('notices.cadena.invitation.token_error')
      redirect_to root_path
    end
  end
end
