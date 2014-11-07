class UsersController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(allowed_params)
    if @user.save
      session[:user_id] = @user.id
      update_records_if_the_registrant_was_a_non_registered_wageree(@user)
      flash[:notice] = "Thanks for registering #{@user.username}. You are now logged in."
      UserMailer.welcome_email(@user).deliver
      redirect_to user_dashboard_path
    else
      render :new
    end
  end

  private

  def allowed_params
    params.require(:user).permit(
      :username,
      :first_name,
      :last_name,
      :email,
      :password,
      :timezone
    )
  end

  def update_records_if_the_registrant_was_a_non_registered_wageree(user)
    non_registered_wageree = NonRegisteredWageree.find_by(email: user.email)
    if non_registered_wageree
      wager = Wager.find(non_registered_wageree.wager.id)
      wager.wageree_id = user.id
      wager.save
      non_registered_wageree.destroy
    end
  end

end