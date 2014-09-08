class UsersController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end



  def create
    @user = User.new(allowed_params)
    if @user.save
      session[:user_id] = @user.id


      if NonRegisteredUser.find_by(email: @user.email)
        non_registered_user = NonRegisteredUser.find_by(email: @user.email)
        wager = Wager.find(non_registered_user.wager.id)
        wager.wageree_id = @user.id
        wager.save
        non_registered_user.destroy
      end

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
      :password
    )
  end





end