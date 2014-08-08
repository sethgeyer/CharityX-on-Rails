class MvpsController < ApplicationController
  def index
    @mvps = Mvp.all
    @the_dude = User.find(session[:user_id]) if session[:user_id]
  end


 def new
   @mvp = Mvp.new
    the_dude = User.find(session[:user_id])
    if the_dude.is_admin?
      render :new
    else
      flash[:notice] = "You don't have permissions to add an MVP"
      redirect_to mvps_path
    end
  end

  def create
    Mvp.create(date: params[:mvp][:date], description: params[:mvp][:description])
    redirect_to mvps_path
  end



end