class CadenaPreviewController < ApplicationController
  def show
    @invitation = Invitation.find_by(token: params[:token])
    if @invitation && !@invitation.accepted
      @cadena = @invitation.cadena
    elsif @invitation&.accepted || @invitation&.older_than_1h
      flash[:error] = t('notices.cadena.invitation.expired')
      redirect_to root_path
    else
      flash[:error] = t('notices.cadena.invitation.token_error')
      redirect_to root_path
    end
  end
end
