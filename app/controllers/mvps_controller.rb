class MvpsController < ApplicationController

  skip_before_action :ensure_current_user, only: [:index]

  def index
    @mvps = Mvp.all
    @the_dude = current_user if current_user
  end


 def new
   @mvp = Mvp.new
    the_dude = current_user
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