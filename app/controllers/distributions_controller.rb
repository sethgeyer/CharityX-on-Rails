class DistributionsController < ApplicationController
  def index
    if session[:user_id] == nil
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    else
      @account = Account.find_by(user_id: session[:user_id])
      if session[:user_id] == @account.user_id
        @distributions = @account.distributions
        render :index
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    end

  end


  def new
    @charities_for_selection = Charity.all

    if session[:user_id] == nil
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    else
      @account = Account.find_by(user_id: session[:user_id])
      if session[:user_id] == @account.user_id
        @distribution = Distribution.new
      else
        flash[:notice] = "You are not authorized to visit this page"
        redirect_to root_path
      end
    end
  end

  def create
    Distribution.create(account_id: params[:account_id].to_i, amount: params[:distribution][:amount].to_i * 100, charity_id: params[:distribution][:charity_id])
    newest_distribution = Distribution.where(account_id: params[:account_id].to_i).last
    #UNTESTED ########################################################
    Chip.new.cash_out(newest_distribution.account.id, newest_distribution.amount, newest_distribution.date, newest_distribution.charity.id)
    #################
    flash[:notice] = "Thank you for distributing $#{newest_distribution.amount.to_i / 100} from your account to #{newest_distribution.charity.name}"
    redirect_to user_path(session[:user_id])
  end
end