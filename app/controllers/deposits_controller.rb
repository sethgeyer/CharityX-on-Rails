class DepositsController < ApplicationController

  def index
    if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      @deposits = @account.deposits
      @distributions = @account.distributions
      render :index
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def new
    if kenny_loggins.account.id == params[:account_id].to_i #<--- no test written to test whether a sessioned user can view someone else's view
      @account = kenny_loggins.account
      @deposit = Deposit.new
      render :new
    else
      flash[:notice] = "You are not authorized to visit this page"
      redirect_to root_path
    end
  end

  def create
    deposit = Deposit.new
    deposit.account_id = params[:account_id].to_i
    deposit.amount = params[:deposit][:amount].to_i * 100
    deposit.cc_number = params[:deposit][:cc_number].to_i
    deposit.exp_date =params[:deposit][:exp_date]
    deposit.name_on_card = params[:deposit][:name_on_card]
    deposit.cc_type = params[:deposit][:cc_type]
    deposit.date_created = Time.now
    deposit.save!
    newest_deposit = Deposit.where(account_id: params[:account_id].to_i).last
    #UNTESTED ########################################################
    Chip.new.purchase(kenny_loggins.id, newest_deposit.account.id, newest_deposit.amount, newest_deposit.date_created, "available")
    #################
    flash[:notice] = "Thank you for depositing $#{newest_deposit.amount / 100} into your account"
    redirect_to user_path(kenny_loggins)
  end


end