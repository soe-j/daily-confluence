class ApplicationController < ActionController::Base

  def sign_in(user)
    cookies.permanent[:user_token] = user.token
    @current_user = user
  end

  def current_user
    user_token = cookies[:user_token]
    @current_user ||= User.find_by(token: user_token)
  end

  def signed_in?
    !current_user.nil?
  end

  def auth
    unless signed_in?
      redirect_to login_url, notice: "Please sign in."
    end
  end
end
