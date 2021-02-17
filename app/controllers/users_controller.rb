class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    user = User.find_or_create_by(user_params)
    sign_in user
    redirect_to :tasks
  end

  private
    def user_params
      params.require(:user).permit(:token)
    end
end
