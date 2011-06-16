class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user

  private

  def current_user
    session[:user_email] = params[:user_email] if params[:user_email]
    User.where(email: session[:user_email]).first
  end

end
