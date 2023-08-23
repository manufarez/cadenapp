class PagesController < ApplicationController
  # http_basic_authenticate_with name: "cadenapp", password: "Remolacha22!"
  skip_before_action :authenticate_user!

  def index
  end
end
