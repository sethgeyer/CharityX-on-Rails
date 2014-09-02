class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_current_user

  def ensure_current_user
    redirect_to root_path unless kenny_loggins
  end

  def kenny_loggins
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :kenny_loggins

  $ChipValue = 10

end
