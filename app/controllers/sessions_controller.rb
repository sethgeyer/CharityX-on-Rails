class SessionsController < ApplicationController

  skip_before_action :ensure_current_user, only: [:index, :create]

  def index
    @user = User.new
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  def create
    @user = User.find_by(username: params[:user][:username], password: params[:user][:password])
    if @user != nil
      session[:user_id] = @user.id
      flash[:notice] = "Welcome #{@user.username}"
      redirect_to user_path(current_user)
    else
      flash[:notice] = "The credentials you entered are incorrect.  Please try again."
      redirect_to root_path
    end
  end

end