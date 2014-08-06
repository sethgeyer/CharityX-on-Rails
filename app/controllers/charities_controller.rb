class CharitiesController < ApplicationController
  def index
    @charities = Charity.all
  end

  def new
  @charity = Charity.new
  end

  def create
    Charity.create(name: params[:name], tax_id: params[:tax_id], poc: params[:poc], poc_email: params[:poc_email], status: params[:status])
    flash[:notice] = "Thanks for applying"

    redirect_to "/charities"
  end


end
