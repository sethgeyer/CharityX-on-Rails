class SessionsController < ApplicationController

  def index
    @user = User.new
  end

  def destroy
    session.delete(:user_id)
    redirect_to root_path
  end

  def create
    current_user = User.find_by(username: params[:user][:username], password: params[:user][:password])
    if current_user != nil
      set_the_session(current_user)
      flash[:notice] = "Welcome #{session[:username]}"
      redirect_to user_path(session[:user_id])
    else
      flash[:notice] = "The credentials you entered are incorrect.  Please try again."
      redirect_to root_path
    end
  end


  def set_the_session(current_user)
    session[:user_id] = current_user.id
  end







end