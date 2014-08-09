class DistributionsController < ApplicationController


  def index
    if current_user.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = current_user.account
      @distributions = @account.distributions
      render :index
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end


  def new
    if current_user.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = current_user.account
      @distribution = Distribution.new
      @charities_for_selection = Charity.all
      render :new
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def create
    Distribution.create(account_id: params[:account_id].to_i, amount: params[:distribution][:amount].to_i * 100, charity_id: params[:distribution][:charity_id])
    newest_distribution = Distribution.where(account_id: params[:account_id].to_i).last
    #UNTESTED ########################################################
    Chip.new.cash_out(newest_distribution.account.id, newest_distribution.amount, newest_distribution.date, newest_distribution.charity.id)
    #################
    flash[:notice] = "Thank you for distributing $#{newest_distribution.amount.to_i / 100} from your account to #{newest_distribution.charity.name}"
    redirect_to user_path(current_user)
  end
end