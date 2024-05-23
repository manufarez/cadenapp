class NewsletterSubscribersController < ApplicationController
  def create
    @lead = NewsletterSubscriber.new(lead_params)
    if @lead.valid? && valid_captcha?(model: @lead)
      NewsletterSubscriber.link_to_user(@lead)
      redirect_to root_path, notice: t('notices.newsletter.subscribed')
    else
      @lead.errors.details
      redirect_to root_path, notice: t('notices.newsletter.subscription_error')
    end
  end

  private

  def lead_params
    params.require(:newsletter_subscriber).permit(:email)
  end
end
