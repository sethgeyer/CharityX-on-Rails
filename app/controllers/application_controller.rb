class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :ensure_current_user


  def ensure_admin
    redirect_to user_dashboard_path unless kenny_loggins.is_admin?
  end

  def ensure_current_user
    redirect_to root_path unless kenny_loggins
  end

  def kenny_loggins
    @current_user ||= User.find_by(id: session[:user_id])
  end

  helper_method :kenny_loggins

  def amount_stripped_of_dollar_sign_and_commas(user_input_amount)
    user_input_amount.gsub("$", "").gsub(",", "").to_i
  end

  def amount_converted_to_pennies(dollar_amount)
    dollar_amount * 100
  end

end
