class CharitiesController < ApplicationController

  skip_before_action :ensure_current_user

  def index
    @charities = Charity.all
  end

  def new
    @charity = Charity.new
  end

  def create
    @charity = Charity.create(charity_strong_params)
    @charity.status = "unregistered"
    if @charity.save
      flash[:notice] = "Thanks for applying"
      redirect_to charities_path
    else
      flash[:notice] = "DEVELOPER F'D SOMETHING UP"
      redirect_to root_path
    end
  end

  private

  def charity_strong_params
    params.require(:charity).permit(
      :name,
      :tax_id,
      :poc,
      :poc_email,
    )
  end
end
