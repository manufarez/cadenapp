class PagesController < ApplicationController
  # http_basic_authenticate_with name: "cadenapp", password: "Remolacha22!"
  skip_before_action :authenticate_user!

  def index
    if current_user&.is_admin?
      redirect_to cadenas_path
    elsif current_user
      redirect_to dashboard_path
    else
      @lead = NewsletterSubscriber.new
    end
  end

  def terms
  end

  def closed_test
  end

  def faq
    @faqs = YAML.load_file(Rails.root.join("app/views/pages/faq.yml"))
  end
end
