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

  def amount_stripped_of_dollar_sign_and_commas(user_input_amount)
    user_input_amount.gsub("$", "").gsub(",", "").to_i
  end

  def amount_converted_to_pennies(dollar_amount)
    dollar_amount * 100
  end

  def the_user_has_insufficient_funds_for_the_size_of_the_transaction(dollar_amount, status)
    kenny_loggins.chips.where(status: status).count < (dollar_amount / $ChipValue)
  end

  def calculate_the_maximum_dollars_available
    kenny_loggins.chips.where(status: "available").count * $ChipValue
  end


end
