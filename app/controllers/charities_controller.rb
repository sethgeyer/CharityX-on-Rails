class CharitiesController < ApplicationController
  def index
    @charities = Charity.all
  end

  def new
  @charity = Charity.new
  end

  def create
    Charity.create(name: params[:charity][:name], tax_id: params[:charity][:tax_id], poc: params[:charity][:poc], poc_email: params[:charity][:poc_email], status: params[:charity][:status])
    flash[:notice] = "Thanks for applying"

    redirect_to "/charities"
  end


end
