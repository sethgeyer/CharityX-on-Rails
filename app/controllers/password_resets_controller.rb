class PasswordResetsController < ApplicationController

  skip_before_action :ensure_current_user, only: [:new, :create, :edit, :update]

  def new
    @password_reset_request = PasswordReset.new
  end

  def create
    @password_reset_request = PasswordReset.new
    @password_reset_request.email = params[:password_reset][:email]
    @password_reset_request.unique_identifier = 5
    @password_reset_request.expiration_date = Time.now + 1.day
    if @password_reset_request.save
      flash[:notice] = "Password reset instructions have been sent to #{@password_reset_request.email}"
      UserMailer.password_reset_email(@password_reset_request).deliver
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @requester = PasswordReset.where(unique_identifier: params[:id]).first
    # @user = User.find_by(email: user_email)
  end

  def update
    @user = User.find_by(email: params[:email])
    if params[:password] != ""
      @user.password = params[:password]
    end

    if @user.save
      flash[:notice] = "Your password has been updated"
      redirect_to root_path
    else
      flash[:notice] = "Your password must be at least 7 characters"

      @requester = PasswordReset.where(email: params[:email]).first
      render :edit
    end
  end

end