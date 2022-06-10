class PagesController < ApplicationController
  http_basic_authenticate_with name: "cadenapp", password: "Remolacha22!"

  def index
  end
end
