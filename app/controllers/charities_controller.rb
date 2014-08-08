class CharitiesController < ApplicationController
  def index
    @charities = Charity.all
  end

  def new
  @charity = Charity.new
  end

  def create
    charity = Charity.new
    charity.name = params[:charity][:name]
    charity.tax_id = params[:charity][:tax_id]
    charity.poc = params[:charity][:poc]
    charity.poc_email = params[:charity][:poc_email]
    charity.status = params[:charity][:status]
    if charity.save
      flash[:notice] = "Thanks for applying"
      redirect_to charities_path
    else
      flash[:notice] = "DEVELOPER F'D SOMETHING UP"
      redirect_to root_path
    end
  end

end
