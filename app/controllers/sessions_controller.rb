class SessionsController < ApplicationController
  def destroy
    session.delete(:user_id)
    session.delete(:email)
    redirect_to "/"
  end

  def create
    current_user = User.find_by(username: params[:username], password: params[:password])
    if current_user != nil
      set_the_session(current_user)
      flash[:notice] = "Welcome #{session[:username]}"
      redirect_to "/users/#{session[:user_id]}"
    else
      flash[:notice] = "The credentials you entered are incorrect.  Please try again."
      redirect_to "/"
    end
  end


  def set_the_session(current_user)
    session[:user_id] = current_user.id
    session[:username] = current_user.username
  end







end