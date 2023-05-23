class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def login_as
    user = User.find(params[:id])
    sign_in(user, scope: :user)
    redirect_to users_path
  end
end
