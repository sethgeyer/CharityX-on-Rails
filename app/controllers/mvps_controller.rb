class MvpsController < ApplicationController

  skip_before_action :ensure_current_user, only: [:index]

  def index
    @mvps = Mvp.all
  end


 def new
   @mvp = Mvp.new
    if current_user.is_admin?
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