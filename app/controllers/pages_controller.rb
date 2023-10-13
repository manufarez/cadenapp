class PagesController < ApplicationController
  # http_basic_authenticate_with name: "cadenapp", password: "Remolacha22!"
  skip_before_action :authenticate_user!

  def index
    @lead = NewsletterSubscriber.new
  end

  def terms
  end

  def closed_test
  end

  def faq
    @faqs = YAML.load_file(Rails.root.join("app/views/pages/faq.yml").to_s)
  end
end
