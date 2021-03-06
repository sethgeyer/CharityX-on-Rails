class PasswordResetsController < ApplicationController

  require 'securerandom'

  skip_before_action :ensure_current_user, only: [:new, :create, :edit, :update]

  def new
    @password_reset_request = PasswordReset.new
  end

  def create
    @password_reset_request = PasswordReset.new(email: params[:password_reset][:email], unique_identifier: SecureRandom.uuid, expiration_date: Time.now + 1.day)
    if @password_reset_request.save
      flash[:notice] = "Password reset instructions have been sent to #{@password_reset_request.email}"
      UserMailer.password_reset_email(@password_reset_request).deliver
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @secret_uid = params[:id]
    @requester = PasswordReset.find_by(unique_identifier: @secret_uid)
  end

  def update
    @user = User.find_by(email: params[:email])
    if PasswordReset.find_by(unique_identifier: params[:secret_uid]).expiration_date < Time.now.to_date
      flash[:notice] = "Your password reset request has expired.  Please create another request"
      redirect_to root_path

    elsif PasswordReset.where(email: params[:email]).order("id ASC").last.unique_identifier != params[:secret_uid]
      flash[:notice] = "This link is no longer valid."
      redirect_to root_path

    else
      @user.password = params[:password]

      if @user.save
        flash[:notice] = "Your password has been updated."
        redirect_to root_path
      else
        flash[:notice] = "Your password must be at least 7 characters."
        @requester = PasswordReset.find_by(email: params[:email])
        render :edit
      end

    end

  end

end